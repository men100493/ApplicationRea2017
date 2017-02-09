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
import GoogleSignIn

class Helper{
    
    
    
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
            
            GlobalVariables.sharedManager.userProfil = userFB
            
            
            }
            
        }
    }
    
    
    //-------------------------------------
    // MARK: - User Log in 
    //-------------------------------------
    

    static func initViewController(){
        

        
        if GlobalVariables.sharedManager.userProfil != nil {
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
        GlobalVariables.sharedManager.userProfil?.logout()

    }
    
    
    //-------------------------------------
    // MARK: - Get FaceBook User EVent
    //-------------------------------------
    
    static func getFBUserEvents(){
        
        if (FBSDKAccessToken.current()) != nil , GlobalVariables.sharedManager.userProfil != nil {
            
            FBSDKGraphRequest.init(graphPath: "/me/events", parameters: ["fields": "id, name"]).start { (connection, result, error) in
                //print("Wesh")
                
                if error != nil {
                    print("Failed looser  fuck graph request" )
                    return
                }
                print(result ?? "")
            }
        }

       
        
    }

    

        
}
