//
//  LoginViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFBbutton()
        setupGooglebutton()
        
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


    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil  {
            print(error)
            return
        }
        
        getUserData()
        print("Login")
        

        
        
    }
    
    fileprivate func setupGooglebutton(){
        //Add Google Sign in buutton
        
        let googlebutton = GIDSignInButton()
        googlebutton.frame = CGRect(x: 16, y:view.frame.height/3  , width: view.frame.width - 32, height: 50)
        
        view.addSubview(googlebutton)
        //GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    
    func getUserData() {
        FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            //print("Wesh")
            
            if error != nil {
                print("Failed looser  fuck graph request" )
                return
            }
            print(result!)
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
