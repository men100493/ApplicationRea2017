//
//  ChatMessageViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 09/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class ChatMessageViewController: UIViewController {
    @IBOutlet weak var loginBtnOutlet: UIButton!
    var user:User?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHomeViewController()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        initHomeViewController()
        
        
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
        let imagePro = UIImage(named: "Profil") as UIImage?
        
        if self.user != nil {
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            
            loginBtnOutlet.setImage(imagePro, for: .normal)
            
            
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Helper.getUserFBData()
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            loginBtnOutlet.setImage(imagePro, for: .normal)
            
            
            return
        }
        loginBtnOutlet.setTitle("Login", for: .normal)
        loginBtnOutlet.imageView?.image = nil 
        print("Utilisateur non connecté")
        
        
        
    }
   
    
    @IBAction func LoginOrProfile(_ sender: Any) {
        //self.performSegue(let lg = LoginViewController()
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if loginBtnOutlet.image(for: .normal) != nil  {
            
            let vc : ProfilViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfilVC") as! ProfilViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        else{
            
            let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
            
            
            
            
        }
        
        
        
    }
    
    
    
    
    // segue LoginViewController -> HomeViewController
    @IBAction func unwindFromLogin(sender: UIStoryboardSegue) {
        
        if let LoginVC = sender.source as? LoginViewController {
            if LoginVC.user?.isConnectToFireBase() == true , let dataRecieved = LoginVC.user {
                print(dataRecieved )
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                Constants.Users.user =  dataRecieved
                print("BAck From Login")
                
            }
            
        }
    }
    
    @IBAction func unwindFromProfil(sender: UIStoryboardSegue) {
        
        if sender.source is LoginViewController {
            
            print("BAck From Profile")
            
            
            
        }
    }
    
}
