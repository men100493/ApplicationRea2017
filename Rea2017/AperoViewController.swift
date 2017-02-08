//
//  AperoViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class AperoViewController: UIViewController {
        @IBOutlet weak var loginBtnOutlet: UIButton!

     var user = GlobalVariables.sharedManager.userProfil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //-------------------------------------
    // MARK: - Boutton => Log in / Profile
    //-------------------------------------
    
    func initHomeViewController(){
        self.user = GlobalVariables.sharedManager.userProfil
        
        if self.user != nil {
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Helper.getUserFBData()
            self.user = GlobalVariables.sharedManager.userProfil
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
        }
        loginBtnOutlet.setTitle("Login", for: .normal)
        
        print("Utilisateur non connecté")
        
        
        
    }
    
    @IBAction func LoginPushView(_ sender: Any) {
        //self.performSegue(let lg = LoginViewController()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if loginBtnOutlet.titleLabel?.text == "Login" {
            let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
        else{
            let vc : ProfilViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfilVC") as! ProfilViewController
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    
    // segue LoginViewController -> HomeViewController
    @IBAction func unwindFromLogin(sender: UIStoryboardSegue) {
        
        if let LoginVC = sender.source as? LoginViewController {
            if LoginVC.user?.isConnectToFireBase() == true , let dataRecieved = LoginVC.user {
                print(dataRecieved )
                GlobalVariables.sharedManager.userProfil =  dataRecieved
                print("BAck From Login")
                
            }
            
        }
    }
    
    @IBAction func unwindFromProfil(sender: UIStoryboardSegue) {
        
        if let ProfilVC = sender.source as? LoginViewController {
            
            print("BAck From Profile")
            
            
            
        }
    }
    
}
