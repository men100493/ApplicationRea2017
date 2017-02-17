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


}
