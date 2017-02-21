//
//  Apero.swift
//  Rea2017
//
//  Created by MENES SIMEU on 14/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
import Firebase

class Apero: NSObject {
    var id: String
    var name: String? = nil
    //var date: String? = nil
    var nbInvite: String? = nil
    var adresse: String? = nil
    var descrip: String? = nil
    var eventFb: String? = nil
    var start: String? = nil
    var end: String? = nil
    var cp : String? = nil
    var userHost: User? = Constants.Users.user
    var tabInvite = [User]()
    var tabInviteId = [String]()
    
    init(id: String, name:String,nbInvite:String,descrip: String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        //self.adresse = adresse
        self.descrip = descrip
    }
    
    init(id: String, name:String,nbInvite:String,descrip: String, eventFB: String, adresse: String, startTime:String,endTime: String,cp:String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        
        self.descrip = descrip
        self.eventFb = eventFB
        self.adresse = adresse
        self.start = startTime
        self.end = endTime
        self.cp = cp
    }
    
    
    
    
    func observeEvent(){
        //let dic = [String: AnyObject]()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        //AFINIR MENES
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        ref.child("Apero").child(self.id).observe(.value, with: { (snapshot) in
            
            print(snapshot)
            
            let dic = snapshot.value as?  NSDictionary
            print(dic)
            if dic != nil {
                
               // let values = ["id":self.id, "title": self.name, "description": self.descrip, "FBEventId": self.eventFb, "nbGuest": self.nbInvite!, "address":self.adresse, "commence a": self.start, "fini a": self.end!, "cp": self.cp!, "UserHostId":(userHost?.id!)! as String] as [String : Any]
                let aperoname = dic?["name"] as? String
                let aperodescr = dic?["description"] as? String
                let aperonb = dic?["nbGuest"] as? String
                let aperostart = dic?["commence a"] as? String
                
                
                if aperoname != nil, aperodescr != nil{
                    self.name = aperoname
                    self.descrip = aperodescr
                    
                }
                if let aperoInvite = dic?["Invite"] as? [String: AnyObject]{
                    var tabUser = [String]()
                    for apero in aperoInvite{
                        tabUser.append(apero.key )
                        //self.tabAperoId.append(id.key as! String)
                    }
                    self.tabInviteId = tabUser
                    
                }
            }
            
        })
        //print(dic)
        
    }

    func saveAperoToBDD() {
        
        
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["id":self.id, "title": self.name, "description": self.descrip, "FBEventId": self.eventFb, "nbGuest": self.nbInvite!, "address":self.adresse, "commence a": self.start, "fini a": self.end!, "cp": self.cp!, "UserHostId":(userHost?.id!)! as String] as [String : Any]
        
        let usersReference = ref.child("Apero").child(self.id)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
    }
    
    func saveEventToApero(event: FBEvent) {
        
        let eventId =  event.id
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["FBEventId": eventId ]
        
        let usersReference = ref.child("Apero").child(self.id)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
        
        //Ecrire sur la BBD de L'event l'id de l'apéros associer GOOD LUCK
        
        event.saveAperoToEvent(apero: self)

        
    }
    
    func addUser(user: User){
        //AJouter a la BDD

        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["UserID": user.id,"UserNom": user.nom]
        
        let usersReference = ref.child("Apero").child(self.id).child("Invite").child(user.id!)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
    }
    
    func popUser(user:User){
        
        
    }


}
