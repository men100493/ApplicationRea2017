//
//  FBEvent.swift
//  Rea2017
//
//  Created by MENES SIMEU on 10/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class FBEvent {
    let id: String
    var name: String?
    var date: String?
    var tabAperoId = [String]()
   
    init(id:String, name: String, date: String) {
        self.id = id
        self.name = name
        self.date = date
    }
    
    
    //-------------------------------------
    // MARK: - Watch Event BDD
    //-------------------------------------
    func observeEvent(){
        //let dic = [String: AnyObject]()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        ref.child("FBevent").child(self.id).observe(.value, with: { (snapshot) in
            print(snapshot)
            let dic = snapshot.value as?  NSDictionary
            //print(dic ?? "")
            if dic != nil {
            
                
                    let eventname = dic?["name"] as? String
                    let eventdate = dic?["date"] as? String
                
                    if eventname != nil, eventdate != nil{
                        self.name = eventname
                        self.date = eventdate
                   
                    }
                if let eventAperos = dic?["Aperos"] as? [String: AnyObject]{
                    var tabId = [String]()
                    for id in eventAperos{
                        tabId.append(id.key as! String)
                        //self.tabAperoId.append(id.key as! String)
                    }
                    self.tabAperoId = tabId
                
            }
            }

        })
        //print(dic)
        
    }
    
    func isSetInBDD() -> Bool{
        var isinBDD = false
        let refBDD = FIRDatabase.database().reference().child("FBEvent")
        refBDD.queryOrdered(byChild: "id").queryEqual(toValue: "\(self.id)")
            .observe(.value, with: { snapshot in
                
                if ( snapshot.value is NSNull ) {
                   // print("not found)")
                    
                    
                } else {
                    isinBDD = true
                    //print(snapshot)
                }
        })
        return isinBDD
        
       
    }
    //-------------------------------------
    // MARK: - Save Event BDD
    //-------------------------------------
    func saveEventToDataBase() {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["name": self.name ,"date": self.date]
        
        let usersReference = ref.child("FBevent").child(self.id)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            
            //print(values)
        }
        //self.observeEvent()
    }
    
    func saveAperoToEvent(apero: Apero) {
        
        
        apero.saveEventToApero(event: self)
        
        let apId = apero.id
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["AperoId": apId, "AperoNom": apero.name ,"userHost":Constants.Users.user?.id as Any] as [String : Any]
        
        let usersReference = ref.child("FBevent").child(self.id).child("Aperos").child(apId)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
            self.observeEvent()
        }
    }
    

    


}
