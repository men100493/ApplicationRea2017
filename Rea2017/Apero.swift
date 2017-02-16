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
    //var adresse: String? = nil
    var descrip: String? = nil
    var evenFb: String? = nil
    
    init(id: String, name:String,nbInvite:String,descrip: String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        //self.adresse = adresse
        self.descrip = descrip
    }
    
    func saveEventToApero(event: FBEvent) {
        
        let eventId =  event.id
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["FBEventId": eventId, "FBEventNom": event.name ]
        
        let usersReference = ref.child("Apero").child(self.id).child("EventId").child(eventId)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
    }


}
