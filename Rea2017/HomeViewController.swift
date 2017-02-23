//
//  HomeViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class HomeViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource ,UITextFieldDelegate {
    
    var user :User?
    var tableHomePossible = [FBEvent]()
    var tableHome = [FBEvent]()
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        Helper.initViewController()
        Helper.getFBEvents()
        initHomeViewController()
        homeTableView.delegate = self
        searchTextField.delegate = self
        tableHomePossible = Constants.Events.tabEvent
        customView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        getMusicevent()
        initHomeViewController()

    }
    
    //-------------------------------------
    // MARK: -  Custom View
    //-------------------------------------
    
    
    func customView() {
        
        let imageName = "RechercheEve"
        let imageHome = UIImage(named: imageName)
        let imageView = UIImageView(image: imageHome!)
        imageView.frame = CGRect(x: (self.view.frame.size.width/2)-50, y: (self.view.frame.size.height/7)-50, width: 100 , height:100 )
        view.addSubview(imageView)
        
        let fdColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.backgroundColor = fdColor
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.borderStyle = UITextBorderStyle.roundedRect
        searchTextField.textColor = UIColor.black
        
    }

    //-------------------------------------
    // MARK: -  Get MUSIC EVENT
    //-------------------------------------

    func getMusicevent(){
        //
        //Helper.getFBUserEvents()
        
        if tableHomePossible.count == 0 {
            for event in Constants.Events.tabEvent {
                self.tableHome.append(event)
                self.tableHomePossible.append(event)
            }
            self.homeTableView.reloadData()
        
        }
        

    
    }
    
    
    //-------------------------------------
    // MARK: -  TableView And TexField
    //-------------------------------------

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHome.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.tableHome[indexPath.row].name!
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Paris est magique")
        tableView.deselectRow(at: indexPath, animated: true)
        let selected:FBEvent = self.tableHome[indexPath.row]
        if !selected.id.isEmpty{
            performSegue(withIdentifier: "HomeToEventSegue", sender: selected)
        
        }
        
        
        
        
    }
    
    //TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //var myRange: NSRange = NSMakeRange(0, 2)
        let oldText = textField.text!
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        //let substring = (textField.text! as String).replacingCharacters(in: range.toRange(), with: string)
        searchAutocompleteEntriesWithSubstring(substring: newText)
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        
        let length = substring.characters.count
        if length >= 3 {
            self.tableHome.removeAll(keepingCapacity: false)
            for event in Constants.Events.tabEvent
            {
                let myString = event.name as NSString!
                //let myString2 = user.pnom as NSString!
                //let substringRange :NSRange! = myString!.range(of: substring)
                let sub = myString?.substring(to: length)
                //let sub2 = myString2?.substring(to: length)
                if (sub?.lowercased()  == substring.lowercased() )
                {
                    tableHome.append(event)
                }
            }
            
            homeTableView.reloadData()
        }else{
            self.tableHome = tableHomePossible as! [FBEvent]
            homeTableView.reloadData()
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
        getMusicevent()
        
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
        Helper.getBDDEvents()
        Helper.getBDDAperos()

        
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "HomeToEventSegue" {
            if let event = sender as! FBEvent?{
                let destVC = segue.destination as! DetailEventViewController
                destVC.event = event
                destVC.eventId = event.id
            }else{
                return
            }
            
        }
        
    }
    


}
