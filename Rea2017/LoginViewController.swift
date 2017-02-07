//
//  LoginViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFBbutton()
        setupGooglebutton()
        
        
        if (FBSDKAccessToken.current() != nil) && GlobalVariables.sharedManager.userProfil == nil  {
            getUserFBData()
        }
        
    
        
        //view.addSubview(self.loginFBButton)

        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func setupFBbutton(){
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y:view.frame.height/4 , width: view.frame.width - 32, height: 50)
        
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    fileprivate func setupGooglebutton(){
        //Add Google Sign in buutton
        
        let googlebutton = GIDSignInButton()
        googlebutton.frame = CGRect(x: 16, y:(view.frame.height/4 )+70  , width: view.frame.width - 32, height: 50)
        
        view.addSubview(googlebutton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
    }
    
    

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil  {
            print(error)
            return
        }
        
        getUserFBData()
        //print("Login")
        self.performSegue(withIdentifier: "backHome", sender: nil)
    
    }
    
    
    func getUserFBData() {
        
        let accesToken = FBSDKAccessToken.current()
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accesToken?.tokenString)!)
     
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
            userFB.conectToFireBase()
            userFB.saveUserToDataBase()
            
            self.user = userFB
            GlobalVariables.sharedManager.userProfil = userFB
             
            //self.userConnexion(user: userFB)
            
            
            }
        }
    
    



    
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
