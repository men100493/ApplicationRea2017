//
//  EventViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase

    
class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var eventTableView: UITableView!
    var user :User?
    var tabEvent :[FBEvent] = []
    @IBOutlet weak var loginBtnOutlet: UIButton!
    //@IBOutlet weak var EventTableView: UITableView!
    
    let animals = ["Cat", "Dog", "Cow", "Mulval"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        eventTableView.alpha = 1
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
//       let  ref = FIRDatabase.database().reference()
//        
//
//        let databaseHandle = ref.child("FBevent").observe(.childAdded, with: { (snapshot) in
//            let event = snapshot.value as? String
//            if let actualEvent = event {
//                
//                self.getEvent()
//                self.eventTableView.reloadData()
//            }
//        })
//        
        
        
        
                // Do any additional setup after loading the view.
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initHomeViewController()
        if user != nil {
            if (user?.isConnectToFireBase())!{
                getEvent()
            }
        }
        
        //self.eventTableView.reloadData()


        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: - TableVIew Handler
    //-------------------------------------
    
//    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return tabEvent.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if user?.isConnectToFireBase() == false {
            //
        }else{
        
            cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
            cell?.textLabel?.text = tabEvent[indexPath.row].name
            cell?.detailTextLabel?.text =  tabEvent[indexPath.row].date
        
        
        }

        return cell!
    }
    
    //-------------------------------------
    // MARK: - Get User Event
    //-------------------------------------
    
    func getEvent(){
        if (user?.isConnectToFacebook())! {
            Helper.getFBUserEvents()
        }
        
        //get event from BDD
       Helper.getBDDEvents()
        if (user?.isConnectToFireBase())! , Constants.Events.tabEvent != nil  {
            tabEvent = Constants.Events.tabEvent!
            
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
        
        if self.user != nil {
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Helper.getUserFBData()
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
        }
        loginBtnOutlet.setTitle("Login", for: .normal)
        
        print("Utilisateur non connecté")
        
        
        
    }
    
    
    @IBAction func LoginOrProfile(_ sender: Any) {
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
