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
    func observeEvent() -> [String: AnyObject]{
        let dic = [String: AnyObject]()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("FBEvent").child(uid!).observe(.value, with: { (snapshot) in
           // print(snapshot)
            let dic = snapshot.value as?  [String: AnyObject]
            for event  in dic!{
                let eventid = event.key as? String
                
                let eventname = event.value["nom"] as? String
                let eventdate = event.value["date"] as? String
                
                if eventid != nil, eventname != nil, eventdate != nil{
                    self.name = eventname
                    self.date = eventdate
                   
                }
                let eventAperos = event.value["Aperos"] as? [String: AnyObject]
                for id in eventAperos!{
                    self.tabAperoId.append(id.value as! String)
                    
                
                }
                
            }

        })
        //print(dic)
        return dic
        
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
    }
    
    func saveAperoToEvent(apero: Apero) {
        
        let apId = apero.id
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["AperoId": apId, "AperoNom": apero.name ]
        
        let usersReference = ref.child("FBevent").child(self.id).child("Aperos").child(apId)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
    }

}
