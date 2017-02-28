//
//  Helper.swift
//  Rea2017
//
//  Created by MENES SIMEU on 08/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class Helper{
    var ref: FIRDatabaseReference!
    var myGroup = DispatchGroup()
    
    
    
    
    //-------------------------------------
    // MARK: - Google is Connected ?
    //-------------------------------------
    
    
    static func isConnectToGoogle() -> Bool {
        if GIDSignIn.sharedInstance() != nil {
            return true
        }
        return false
    }

    
    //-------------------------------------
    // MARK: - Facebook is Connected ?
    //-------------------------------------
    

    static func isConnectToFacebook() -> Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        }
        return false
    }
    
    //-------------------------------------
    // MARK: - Facebook Data RQ
    //-------------------------------------
    
    
    static func getUserFBData() {
        
        
            if (FBSDKAccessToken.current()) != nil{
                
                FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large),birthday"]).start { (connection, result, error) in
                    print(result)
                    
                    if error != nil {
                        print("Failed looser  fuck graph request" )
                        return
                    }
                    
                    let usrDict = result as! [String : AnyObject]
                    let profilePictureURLStr = (usrDict["picture"]!["data"]!! as! [String : AnyObject])["url"]
                    let userid = usrDict["id"] as! String
                    let userName = usrDict["last_name"] as! String
                    let userFName = usrDict["first_name"] as! String
                    let userMail = usrDict["email"] as! String
                    let usernaiss = usrDict["birthday"] as! String
                    //let profilPic = usrDict["picture"]!["data"]! as! [String : AnyObject])["url"]as! String
                    //(data["picture"]!["data"]!! as! [String : AnyObject])["url"]as! String
                    //let profilPic = usrDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("data"") as! String
                    print(usernaiss)
                    //print(userName)
                    
                    
                    
                    //Création de l'utilsateur FB
                    
                    let userFB = User(nom: userName, pnom: userFName, email: userMail,fbId: userid,imageUrl :profilePictureURLStr as! String,naiss: usernaiss)
                    //let userFB = User(nom: userName, pnom: userFName, email: userMail,fbId: userid,imageUrl :profilePictureURLStr as! String)
                    
                    //Firebase Setup
                    let accesToken = FBSDKAccessToken.current()
                    let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accesToken?.tokenString)!)
                    userFB.conectToFireBase(credentials: credentials)
                    userFB.saveUserToDataBase()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    Constants.Users.user = userFB
                    print(Constants.Users.user?.id)
                    Constants.Users.user?.getEventAsFav()
                    //Constants.Users.user?.getFBPicture()
                    
                }
                
            
        
        }
        
    }
    
    
    //-------------------------------------
    // MARK: - User Log in 
    //-------------------------------------
    

    static func initViewController(){
        for event in Constants.Events.tabEvent {
            event.getCoverURL()
        }
        
        
        if Constants.Users.user != nil {
            print("Utilisateur connecté")
            Constants.Users.user?.getFBUptade()
            Helper.getBDDEvents()
            Helper.getBDDAperos()
            Helper.getBDDUser()
            Constants.Users.user?.getEventAsFav()
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Constants.Users.user?.getFBUptade()
            print("Utilisateur connecté a FB")
            // Création de l'utisateur et Connection a Facebook
            //Helper.getUserFBData()
            Helper.getBDDEvents()
            Helper.getBDDAperos()
            Helper.getBDDUser()
            Helper.getFBEvents()
            Constants.Users.user?.getEventAsFav()
            print("Utilisateur connecté")
            return
            
        }
        
        print("Utilisateur non connecté")
        
        
        
        
    }
    
    //-------------------------------------
    // MARK: - User Log in
    //-------------------------------------

    static func logout(){

        Constants.Users.user?.logout()

    }
    
    
    static func getFBEvents(){
        Helper.getFBLyonEvents()
    }
    //-------------------------------------
    // MARK: - Get FaceBook Lyon EVent
    //-------------------------------------
    
    static func getFBLyonEvents() {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if (FBSDKAccessToken.current()) != nil {
            
            FBSDKGraphRequest.init(graphPath: "/search",
                                   parameters: ["q": "Lyon","type": "event",]).start { (connection, result, error) in
                                    //print("Wesh")
                                    
                                    if error != nil {
                                        print("Failed looser fuck graph request" )
                                        return
                                    }
                                    //print(result)
                                    
                                    //Recuperation des Evenement FB
                                    let resultat = result as? NSDictionary
                                    if let eventData = resultat?["data"] as? [Dictionary<String,AnyObject>]{
                                        //print(eventData)
                                        for event in eventData {
                                            // Access event data
                                            let eventid = event["id"] as? String
                                            let eventname = event["name"] as? String
                                            let eventdate = event["start_time"] as? String
                                            
                                            //let eventcover = event["cover"] as? NSDictionary
                            
                                            let eventplace = event["place"] as? NSDictionary
                                            
                                            
                                            var  event :FBEvent?
                                            if let place:String = eventplace?["name"] as! String {
                                                print( place)
                                                event = FBEvent(id: eventid!, name: eventname! , date: eventdate!,place: place)
                                                
                                            
                                            }else{
                                                event = FBEvent(id: eventid!, name: eventname! , date: eventdate!)
                                            }
                                            
                                            event?.getCoverURL()

                                            //print(eventplace)
                                            let isSet = event?.isSetInBDD()
                                            if isSet == false  {
                                                //Ajout a la bdd
                                                
                                                event?.saveEventToDataBase()
                                                
                                                //print("BDDDDDDDDDDDDDd")
                                            }
                                            
                                            
                                            
                                        }
                                    }
                                    
            }
        }
    }
    

    
    //-------------------------------------
    // MARK: - Get FaceBook User EVent
    //-------------------------------------
    
    static func getFBUserEvents() {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        

        
        if (FBSDKAccessToken.current()) != nil , Constants.Users.user != nil {
            
            FBSDKGraphRequest.init(graphPath: "/me/events",
                                   parameters: ["fields": "id,name,start_time",]).start { (connection, result, error) in
                //print("Wesh")
                
                if error != nil {
                    print("Failed looser fuck graph request" )
                    return
                }
                //print(result)
                //Recuperation des Evenement FB
                                    let resultat = result as? NSDictionary
                                    if let eventData = resultat?["data"] as? [Dictionary<String,AnyObject>]{
                                    //print(eventData)
                                    for event in eventData {
                                        // Access event data
                                        let eventid = event["id"] as? String
                                        let eventname = event["name"] as? String
                                        let eventdate = event["start_time"] as? String
                                        //print(eventname)
                                        let event = FBEvent(id: eventid!, name: eventname! , date: eventdate!)
                                        let isSet = event.isSetInBDD()
                                        if isSet == false  {
                                            //Ajout a la bdd
                                            
                                            event.saveEventToDataBase()
                                            //print("BDDDDDDDDDDDDDd")
                                        }


                                        
                                    }
                                }
   
                            }
                }
            }

    
    //-------------------------------------
    // MARK: - Get Aperos From DataBase
    //-------------------------------------
    
    
    static func getBDDAperos()  {
        var tabApero = [Apero]()
        let refBDD = FIRDatabase.database().reference().child("Apero").observe(.value, with: { (snapshot) in
            
            if let dic = snapshot.value as?  [String: AnyObject] {
                //print(dic)
                for apero  in dic{
                    let aperoid = apero.key as? String
                    
                    let aperoname = apero.value["title"] as? String
                    let aperoevent = apero.value["event"] as? String
                    let aperoinvite = apero.value["nbGuest"] as? String
                    let aperodescription = apero.value["description"] as? String
                    //let aperoadress = apero.value["adress"] as? String
                    
                    if aperoname != nil, aperoid != nil {
                        let apero = Apero(id: aperoid!, name: aperoname!, nbInvite: aperoinvite!,  descrip: aperodescription!)
                        tabApero.append(apero)
                        
                        //Constants.Aperos.tabEApero? = tabApero
                        //print(tabApero.count)
                        
                    }

                    
                }
                Constants.Aperos.tabEApero = tabApero
                
                
                //print(Constants.Aperos.tabEApero.count)
            }
        })

    }
    //-------------------------------------
    // MARK: - Get Event From DataBase
    //-------------------------------------
    
    static func getBDDEvents(){
        //let dicEvent : NSDictionary? = nil
        var tabEve = [FBEvent]()
        let refBDD = FIRDatabase.database().reference().child("FBevent").observe(.value, with: { (snapshot) in
            //print(snapshot)
            if let dic = snapshot.value as?  [String: AnyObject] {
                //print(dic)
                for event  in dic{
                    let eventid = event.key as? String
                    
                    let eventname = event.value["name"] as? String
                    let eventdate = event.value["date"] as? String
                    let eventplace = event.value["place"] as? String
                    
                    
                    if eventid != nil , eventname != nil, eventdate != nil, eventplace != nil {
                        let event = FBEvent(id: eventid!, name: eventname! , date: eventdate!,place: eventplace!)
                        event.getCoverURL()
                        tabEve.append(event)
                        //Constants.Events.tabEvent = tabEve
                        //Constants.Events.addEvent(event)
                        //print(event.date)
                    }
                    
                }
                Constants.Events.tabEvent = tabEve
                //print(Constants.Events.tabEvent?.count)
                //print(tabEve.count)
               
            }
            
        })
        

    }
    
    //-------------------------------------
    // MARK: - Get Event From DataBase
    //-------------------------------------
    
    static func getBDDUser(){
        var tabUser = [User]()
        let refBDD = FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
            //print(snapshot)
            if let dic = snapshot.value as?  [String: AnyObject] {
                //print(dic)
                for user  in dic{
                    var userid = user.key as? String
                    
                    var usernom = user.value["nom"] as? String
                    var usermail = user.value["email"] as? String
                    var userFBid = user.value["fbid"] as? String
                    //let useradd = user.value["adress"] as? String
                    //let usermusic = user.value["music"] as? String
                    var userprenom = user.value["prenom"] as? String
                    var userphoto = user.value["PhotoUrl"] as? String
                    var usernaiss = user.value["naiss"] as? String
                    
                    if userid != nil , usernom != nil, usermail != nil{
                        let user = User(nom: usernom!, pnom: userprenom!, email: usermail!, fbId: userFBid!, naiss: usernaiss!)
                        user.getFBUptade()
                        tabUser.append(user)
                        //Constants.Events.tabEvent = tabEve
                        //Constants.Events.addEvent(event)
                        //print(event.date)
                    }
                    
                    userid = nil
                    usermail = nil
                    userprenom = nil
                    userFBid = nil
                    usernom = nil
                    usernaiss = nil
                    userphoto = nil
                    
                }
                Constants.Users.tabUser = tabUser
                //print(Constants.Events.tabEvent?.count)
                //print(tabEve.count)
                
            }
            
        })
    
    
    }
    

    
    
    

}




