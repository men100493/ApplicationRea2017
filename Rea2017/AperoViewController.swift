//
//  AperoViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class AperoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var aperoTableView: UITableView!
    var user:User?
    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var aperoData = [String]()
    var aperoID = [String]()
    var aperoView:Apero?
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = Constants.Users.user
        Helper.initViewController()
        
        aperoTableView.delegate = self
        aperoTableView.dataSource = self
        
        //set the firebase reference
        ref = FIRDatabase.database().reference()
        
        databaseHandle = ref?.child("Apero").observe(.childAdded, with: { (snapshot) in
            // let apero = snapshot.value["title"] as? String
            let value = snapshot.value as? NSDictionary
            //print(value)
            let aperotitle = value?["title"] as? String?
            let aperoid = snapshot.key as? String?
            //let apero = snapshot.childSnapshot(forPath: "title").value as! String
            if let actualApero = aperotitle {
                self.aperoData.append(actualApero!)
                self.aperoID.append(aperoid!!)
                self.aperoTableView.reloadData()
            }
        })
        
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aperoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aperoCell")
        cell?.textLabel?.text = aperoData[indexPath.row]
        //let label = cell?.viewWithTag(1) as! UILabel
        //label.text = aperoData[indexPath.row]
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let aperoid = aperoID[indexPath.row]
        for apero in Constants.Aperos.tabEApero {
            if (aperoid == apero.id){
                self.aperoView = apero
                print(apero.name)
                //print("Menes Menes mens")
                performSegue(withIdentifier: "aperoPageSegue", sender: nil)
                
            }
        }

        
        //if let event = Constants.Events.tabEvent.first(where: { $0.id == eventid! }){
        // Segue to the second view controller
       
        
        
    }
    
    
    
    
    @IBAction func addAperosBtn(_ sender: Any) {
        performSegue(withIdentifier: "aperoSegue", sender: nil)
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
    //-------------------------------------
    // MARK: - Segue handler
    //-------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "aperosSegue" {
           print("new apéros")
        }
        
        if segue.identifier == "aperoPageSegue" {
            //print("AAAAApéros")
            if let AperoVC = segue.destination as? AperoPageViewController{
                AperoVC.apero = self.aperoView

            }
            
            //self.aperoView
        }
        
        
        
    }

    
    
    
    
    // segue LoginViewController -> HomeViewController
    @IBAction func unwindFromLogin(sender: UIStoryboardSegue) {
        
        if let LoginVC = sender.source as? LoginViewController {
            if LoginVC.user?.isConnectToFireBase() == true , let dataRecieved = LoginVC.user {
                //print(dataRecieved )
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
    
    @IBAction func unwindFromNewApero(sender: UIStoryboardSegue) {
        
        if sender.source is AperoViewController {
            
            print("BAck From Nouvelle apéros")
            
            
            
        }
    }
    
    @IBAction func unwindFromAperoPage(sender: UIStoryboardSegue) {
        
        if sender.source is AperoViewController {
            
            print("BAck From Nouvelle apéros")
            
            
            
        }
    }
    
}
