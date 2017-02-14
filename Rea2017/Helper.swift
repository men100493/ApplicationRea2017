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
        
        FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email"]).start { (connection, result, error) in
            //print("Wesh")
            
            if error != nil {
                print("Failed looser  fuck graph request" )
                return
            }
            let usrDict = result as! [String : AnyObject]
            let userid = usrDict["id"] as! String
            let userName = usrDict["last_name"] as! String
            let userFName = usrDict["first_name"] as! String
            let userMail = usrDict["email"] as! String
            
            //print(userName)
            
            
            
            //Création de l'utilsateur FB
            
            let userFB = User(nom: userFName, pnom: userName, email: userMail,fbId: userid)
            
            
            //Firebase Setup
            let accesToken = FBSDKAccessToken.current()
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accesToken?.tokenString)!)
            userFB.conectToFireBase(credentials: credentials)
            userFB.saveUserToDataBase()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            Constants.Users.user = userFB
            
            }
            
        }
    }
    
    
    //-------------------------------------
    // MARK: - User Log in 
    //-------------------------------------
    

    static func initViewController(){
        
        if Constants.Users.user != nil {
            print("Utilisateur connecté")
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            print("Utilisateur connecté a FB")
            // Création de l'utisateur et Connection a Facebook
            Helper.getUserFBData()
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
                print(result)
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
                    
                    if eventid != nil , eventname != nil, eventdate != nil{
                        let event = FBEvent(id: eventid!, name: eventname! , date: eventdate!)
                        tabEve.append(event)
                        Constants.Events.tabEvent = tabEve
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
    

}
        
        
        
       
