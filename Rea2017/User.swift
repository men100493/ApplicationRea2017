//
//  User.swift
//  TestFirebasechat
//
//  Created by MENES SIMEU on 03/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    var id: String?
    var pnom: String?
    var nom: String?
    var email: String?
    var fbId:  String?
    var fireBaseId:  String?
    var googleId:  String?
    var actif:  Bool = false
    
   
    init(nom: String, pnom: String, email:  String, fbId: String ) {
        let uuid = NSUUID().uuidString
        self.id = uuid
        self.nom =  nom
        self.pnom =  pnom
        self.email = email
        self.fbId = fbId
    }
    
    init(nom: String, pnom: String, email:  String, googleId: String ) {
        let uuid = NSUUID().uuidString
        self.id = uuid
        self.nom =  nom
        self.pnom =  pnom
        self.email = email
        self.googleId = googleId
    }
    
    func conectToFireBase(credientials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credientials, completion: { (user, error) in
            if error != nil {
                print("Failed to create  a fireBse user aAcount: ", error ?? "")
                return
            }
            //Conecté a FIREBASE 
            
            guard let uid = user?.uid else {
                return
            }
            self.fireBaseId = uid

            print("FIREBASE")
            
            
    
    
    })
}
    func isConnectToFireBase() -> Bool{
        if fireBaseId == nil {
            return false
        }else{
            return true
        }
    }

    
    func isConnectToFacebook() -> Bool{
        if fbId == nil {
            return false
        }else{
            return true
        }
    }
    
    func isConnectToGoogle() -> Bool{
        if googleId == nil {
            return false
        }else{
            return true
        }
    }
    
    func isActive() -> Bool{
        return actif
    }
    
    func setActif ()  {
        if actif{
            actif = false
        
        }else{
            actif = true
        }
    }



}
