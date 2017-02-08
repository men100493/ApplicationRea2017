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
            Helper.getUserFBData()
        }
        
    
        
        //view.addSubview(self.loginFBButton)

        // Do any additional setup after loading the view.
    }
    
    //-------------------------------------
    // MARK: - Facebook Login Button Setup
    //-------------------------------------

    fileprivate func setupFBbutton(){
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y:view.frame.height/4 , width: view.frame.width - 32, height: 50)
        
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    
    
    //-------------------------------------
    // MARK: - Facebook Login Button Handle
    //-------------------------------------

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout")
        GlobalVariables.sharedManager.userProfil?.logout()
        GlobalVariables.sharedManager.userProfil = nil
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil  {
            print(error)
            return
        }
        // Création de l'utisateur et Connection a Facebook
        Helper.getUserFBData()
        //print("Login")
        self.performSegue(withIdentifier: "backHome", sender: nil)
    
    }
    //-------------------------------------
    // MARK: - Google Login Button Setup
    //-------------------------------------
    
    fileprivate func setupGooglebutton(){
        //Add Google Sign in buutton
        
        let googlebutton = GIDSignInButton()
        googlebutton.frame = CGRect(x: 16, y:(view.frame.height/4 )+70  , width: view.frame.width - 32, height: 50)
        
        view.addSubview(googlebutton)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
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
