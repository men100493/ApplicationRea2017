//
//  User.swift
//  TestFirebasechat
//
//  Created by MENES SIMEU on 03/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase


class User: NSObject {
    
    //Variables de la classe
    //let ref : FIRDatabaseReference!
    //let urlData = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
    var id: String?
    var pnom: String?
    var nom: String?
    var naiss: String?
    var email: String?
    var fbId:  String?
    var googleId:  String?
    var photoProfilUrl: String?
    var tabApero: [Apero]?

    
   
    init(nom: String, pnom: String, email:  String, fbId: String ) {
        //let uuid = NSUUID().uuidString
        self.id = fbId
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = fbId
        self.googleId = nil
        //self.ref =  FIRDatabase.database().reference()
    }
    
    init(nom: String, pnom: String, email:  String, fbId: String,imageUrl :String ) {
        //let uuid = NSUUID().uuidString
        self.id = fbId
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = fbId
        self.googleId = nil
        self.photoProfilUrl = imageUrl
        //self.ref =  FIRDatabase.database().reference()
    }

    
    init(nom: String, pnom: String, email:  String, fbId: String,imageUrl :String , naiss: String) {
        //let uuid = NSUUID().uuidString
        self.id = fbId
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = fbId
        self.googleId = nil
        self.photoProfilUrl = imageUrl
        self.naiss = naiss
        //self.ref =  FIRDatabase.database().reference()
    }
    
    init(nom: String, pnom: String, email:  String, googleId: String ) {
        //let uuid = NSUUID().uuidString
        self.id = googleId
        self.nom = nom
        self.pnom = pnom
        self.email = email
        self.fbId = nil
        self.googleId = googleId
        //self.ref =  FIRDatabase.database().reference()
    }
    
    
    func getFBUptade() {
        if (FBSDKAccessToken.current()) != nil{
            
            FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large),birthday"]).start { (connection, result, error) in
                //print("Wesh")
                
                if error != nil {
                    print("Failed looser  fuck graph request" )
                    return
                }
                
                let usrDict = result as! [String : AnyObject]
                if let profilePictureURLStr = (usrDict["picture"]!["data"]!! as! [String : AnyObject])["url"]{
                    self.photoProfilUrl = profilePictureURLStr as! String
                }
                let userid = usrDict["id"] as! String
                if let userName = usrDict["last_name"] {
                    self.nom = userName as? String
                }
                if let userFName = usrDict["first_name"]{
                    self.pnom = userFName as! String
                }
                if let userMail = usrDict["email"] {
                    self.email = userMail as! String
                }
                if let usernaiss = usrDict["birthday"] {
                    self.naiss = usernaiss as! String
                }
                self.saveUserToDataBase()
                
            }
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
    
    func getId () -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    
    func logout() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        do{
            try firebaseAuth?.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            Constants.Users.user = nil
            
            
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
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        let values = ["uid": self.id ,"nom": self.nom ,"prenom": self.pnom ,"email": self.email,"fbid": self.fbId,"gid": self.googleId,"naiss": self.naiss,"PhotoUrl": self.photoProfilUrl]
        
        let usersReference = ref.child("users").child(self.id!)

        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create  a fireBase user Acount: ", err ?? "")
                return
            }
            //print(values)
        }
    }
    
    
    func observeUser() -> [String: AnyObject]{
        let dic = [String: AnyObject]()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            //print(snapshot)
            if let dic = snapshot.value as?  [String: AnyObject] {
                //print(dic)
            }
        })
        return dic
        
    }
    
    
    func conectToFireBase(credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Failed to create  a fireBase user aAcount: ", error ?? "")
                return
            }
            //Conecté a FIREBASE
            
            guard (user?.uid) != nil else {
                return
            }
            //assign id
            //self.id = uid
            
            print("FIREBASE")
            
        })
    }
    
    func loginFireBase() {
        if isConnectToFacebook(){
            //Recherche le fbId dans la BDD
            FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
                //print(snapshot)
                if let dic = snapshot.value as?  [String: AnyObject] {
                    print(dic)
                }
            })

            
            
        }
        
        
    }
    
    func deleteEventAsFav(event :FBEvent){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/").child("users").child(self.id!)
        let value = ["nom": event.name , "date":event.date]
        let favReference = ref.child("EventFav").child(event.id)
        
        favReference.removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }

    
    
    
    func saveEventAsFav(event :FBEvent){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/").child("users").child(self.id!)
        let value = ["nom": event.name , "date":event.date]
        let favReference = ref.child("EventFav").child(event.id)
        
        favReference.updateChildValues(value) { (err, data) in
            if err != nil {
                print("Failed to create  a fireBase user Acount: ", err ?? "")
                return
            }
            print(value)
        }
        
        
        
    }
    
    //-------------------------------------
    // MARK: - Get Fav Event
    //-------------------------------------
    
    
    func getEventAsFav(){
        
        
        var tabEve = [FBEvent]()
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/").child("users").child((Constants.Users.user?.id)!)
        //let value = ["nom": event.name , "date":event.date]
        let favReference = ref.child("EventFav")
        favReference.observe(.value, with: { (snapshot) in
            //print(snapshot)
            
            if let dic = snapshot.value as?  [String: AnyObject] {
                print(dic)
                for event  in dic{
                    let eventid = event.key as? String
                    
                    let eventname = event.value["nom"] as? String
                    let eventdate = event.value["date"] as? String
                    
                    if eventid != nil, eventname != nil, eventdate != nil{
                        let event = FBEvent(id: eventid!, name: eventname! , date: eventdate!)
                        tabEve.append(event)
                        //Constants.Events.tabEvent = tabEve
                        //Constants.Events.addEvent(event)
                        print(event.date)
                    }
                    
                }
                Constants.Users.tabEventFav = tabEve
                //print(Constants.Users.tabEventFav.count)
                //print(Constants.Events.tabEvent.count)
                //print(tabEve.count)
                
            }
            
        })

    }
    
    
    func getUserApero(){
        var tab = [Apero]()
        let tabAP = Constants.Aperos.tabEApero
        for apero in tabAP{
            apero.observeApero()
            for id in apero.tabInviteId{
                if id == self.id{
                    tab.append(apero)
                }
            }
            
        }
        self.tabApero = tab
        
    }
    
   }
