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
    var tabEvent = [FBEvent]()
    var eventTitle = [String]()
    var eventId = [String]()
    var eventChoose:String?
    var eventIdChoose:String?
    var row:Int? = nil
    @IBOutlet weak var loginBtnOutlet: UIButton!
    //@IBOutlet weak var EventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHomeViewController()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        //eventTableView.alpha = 1
        
        for event in Constants.Events.tabEvent {
            self.eventTitle.append(event.name!)
            self.eventId.append(event.id)
            //print(event.name)
        }
        
        eventTableView.delegate = self
        eventTableView.dataSource = self


        
                // Do any additional setup after loading the view.
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initHomeViewController()
        if user != nil {
            if (user?.isConnectToFireBase())!{
                getEvent()

            }
        }
        //print(tabEvent)
        
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
        

        return eventTitle.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as UITableViewCell
            cell?.textLabel?.text = self.eventTitle[indexPath.row]

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.row = indexPath.row
        eventChoose = eventTitle[self.row!]
        eventIdChoose = eventId[self.row!]
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        print("Row: \(row)")
        performSegue(withIdentifier: "eventSegue", sender: nil)

        
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
    
    //-------------------------------------
    // MARK: - Segue handler
    //-------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "eventSegue" {
            if eventIdChoose == nil {
                eventIdChoose = eventId[row!]
            }
            let destVC = segue.destination as! DetailEventViewController
                destVC.eventId = eventIdChoose
                print(eventIdChoose)
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
