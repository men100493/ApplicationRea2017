//
//  ChatMessageViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 09/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class ChatMessageViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loginBtnOutlet: UIButton!
    var user:User?

    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var tabApero = [Apero]()
    var channel:Apero?
    
    @IBOutlet weak var chatTableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHomeViewController()
        
        chatTableview.delegate = self
        chatTableview.dataSource = self
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        tabApero = [Apero]()
        for apero in Constants.Aperos.tabEApero {
            tabApero.append(apero)
            
        }
        chatTableview.reloadData()
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        initHomeViewController()
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------------------------------
    // MARK: - TableVIew HAndler
    //-------------------------------------

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabApero.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")
        cell?.textLabel?.text = tabApero[indexPath.row].name
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var valid = true
        print("TG")
        channel = tabApero[indexPath.row]
        
        if channel?.userHostid == Constants.Users.user?.id {
            valid = true
        }
        for id in (channel?.tabInvite)! {
            if id.id == Constants.Users.user?.id {
              valid = true
            }
        }
        
        if valid == true {
            performSegue(withIdentifier: "chatSegue", sender: nil)
        
        }else{
            let alertController = UIAlertController(title: "Problème", message:
                "Vous ne faite pas parti de cette apéros", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        
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
    
    //-------------------------------------
    // MARK: - Boutton => Log in / Profile
    //-------------------------------------
    
    func initHomeViewController(){
        let imagePro = UIImage(named: "Profil") as UIImage?
        loginBtnOutlet.tintColor = Constants.Color.rougeDeClaudius
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
        loginBtnOutlet.setImage(nil, for: .normal)
        loginBtnOutlet.setTitle("Login", for: .normal)
        loginBtnOutlet.setTitleColor(UIColor.white, for: .normal)
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
    
    @IBAction func unwindFromChat(sender: UIStoryboardSegue) {
        
        if sender.source is ChatViewController {
            
            print("BAck From Chat")
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "chatSegue" {
            let destVC = segue.destination as! ChatViewController
            destVC.channel = channel
            destVC.channelRef = FIRDatabase.database().reference().child("Apero").child((channel?.id)!)
            destVC.titreChat = channel?.name
            destVC.senderDisplayName = Constants.Users.user?.pnom
        }
        
        
        
    }
    
}
