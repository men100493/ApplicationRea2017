//
//  HomeViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class HomeViewController: UIViewController {
    
    var user = GlobalVariables.sharedManager.userProfil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            if (FBSDKAccessToken.current() != nil),(user != nil) {
                let lg = LoginViewController()
                self.present(lg, animated: true, completion: nil)
            }
        
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
    
    
    
    // segue LoginViewController -> HomeViewController
    @IBAction func unwindFromLogin(sender: UIStoryboardSegue) {
        print("BAck From Login")
        if let LoginVC = sender.source as? LoginViewController {
            if LoginVC.user?.isConnectToFireBase() == true , let dataRecieved = LoginVC.user {
                print(dataRecieved )
                LoginVC.user?.setActif()
                dataRecieved.setActif()
                GlobalVariables.sharedManager.userProfil =  dataRecieved
                
                self.user = dataRecieved
            }
            
        }
    }

}
