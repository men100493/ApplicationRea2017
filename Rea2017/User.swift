//
//  User.swift
//  TestFirebasechat
//
//  Created by MENES SIMEU on 03/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase

class User: NSObject {
    
    //Variables de la classe
    
    var id: String?
    var pnom: String?
    var nom: String?
    var email: String?
    var fbId:  String?
    var fireBaseId:  String?
    var googleId:  String?

    
   
    init(nom: String, pnom: String, email:  String, fbId: String ) {
        let uuid = NSUUID().uuidString
        self.id = uuid
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = fbId
        self.googleId = nil
        self.fireBaseId = nil
    }
    
    init(nom: String, pnom: String, email:  String, googleId: String ) {
        let uuid = NSUUID().uuidString
        self.id = uuid
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = nil
        self.googleId = googleId
        self.fireBaseId = nil
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
    
    
    func logout() {
        
        
        do{
            try FIRAuth.auth()?.signOut()
            
        }catch let logouterr {
            print(logouterr)
        }
        
    }
    
    func isConnectToFireBase() -> Bool{
        if FIRAuth.auth()?.currentUser?.uid == nil {
            return false
            
        }else{
            return true
            
            
        }

    }

    
  
    //BDD Stuff
    
    func saveUserToDataBase() {
        
        //let ref = FIRDatabase.database().reference(fromURL: "")https://rea2017-f0ba6.firebaseio.com/"
        //ref.updateChildValues(["someValue" : 420000 ])
        let values = ["uid": self.id ,"nom": self.nom ,"prenom": self.pnom ,"email": self.email,"fbid": self.fbId,"gid": self.googleId]
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        let usersReference = ref.child("users").child(self.id!)

        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create  a fireBase user Acount: ", err ?? "")
                return
            }
            print(values)
        }
    }
    
    
    func observe() -> [String: AnyObject]{
        let dic = [String: AnyObject]()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            print(snapshot)
            if let dic = snapshot.value as?  [String: AnyObject] {
                print(dic)
            }
        })
        return dic
        
    }
    func conectToFireBase() {
        
        let accesToken = FBSDKAccessToken.current()
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accesToken?.tokenString)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Failed to create  a fireBase user aAcount: ", error ?? "")
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
    
    func loginFireBase() {
        if isConnectToFacebook(){
            //Recherche le fbId dans la BDD
            FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dic = snapshot.value as?  [String: AnyObject] {
                    print(dic)
                }
            })

            
            
        }
        
        
    }
    

    
    
    




}
