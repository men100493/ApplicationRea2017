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
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            // Do any additional setup after loading the view.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.user = Constants.Users.user
            Helper.initViewController()
            Helper.getFBEvents()
            
            
            
            DispatchQueue.main.async {
                
                self.initHomeViewController()
                self.homeTableView.delegate = self
                self.searchTextField.delegate = self
                self.tableHomePossible = Constants.Events.tabEvent
                self.customView()
                self.getMusicevent()
                
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .background).async {
            //print("This is run on the background queue")
            
            DispatchQueue.main.async {
                self.initHomeViewController()
                self.homeTableView.reloadData()
                //print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
       
        
        //getMusicevent()
        

    }
    
    //-------------------------------------
    // MARK: -  Custom View
    //-------------------------------------
    
    
    func customView() {
        
        let imageName = "RechercheEve"
        let imageHome = UIImage(named: imageName)
        let imageView = UIImageView(image: imageHome!)
        imageView.frame = CGRect(x: (self.view.frame.size.width/2)-40, y: (self.view.frame.size.height/5)-40, width: 80 , height:80 )
        view.addSubview(imageView)
        
        //let fdColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor
        searchTextField.layer.borderWidth = 0
        searchTextField.layer.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor
        //searchTextField.layer.borderColor = UIColor.white.cgColor
        //searchTextField.borderStyle = UITextBorderStyle.roundedRect
        searchTextField.textColor = UIColor.white
        
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.reloadTable))
        
        //let tap1 = UITapGestureRecognizer()
        
        imageView.addGestureRecognizer(tap)
        
    }
    
    func reloadTable() {
        self.homeTableView.reloadData()
        
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
        var cell  = HomeTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as UITableViewCell as! HomeTableViewCell
        
        
        print(self.tableHome[indexPath.row].coverUrlFB)
        
        let coverUrl = self.tableHome[indexPath.row].coverUrlFB
        
        if coverUrl != nil {
            cell.TitleLabel?.isHidden = true
            let url = NSURL(string: coverUrl!)
            let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
            cell.bgCell.image = UIImage(data: data! as Data)
        
        }else{
            cell.TitleLabel?.text = self.tableHome[indexPath.row].name!
        }

        
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! || (textField.text?.characters.count)! <= 3{
            getMusicevent()
            homeTableView.reloadData()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        homeTableView.reloadData()
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
        self.user = Constants.Users.user
        
        let imagePro = UIImage(named: "Profil") as UIImage?
        getMusicevent()
        loginBtnOutlet.tintColor = Constants.Color.rougeDeClaudius
        if self.user != nil {
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            
            loginBtnOutlet.setImage(imagePro, for: .normal)
            loginBtnOutlet.tintColor = Constants.Color.rougeDeClaudius

            
            return
            
        }
        print(Constants.Users.user?.nom)
        
        
        if FBSDKAccessToken.current() != nil {
            Helper.getUserFBData()
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            loginBtnOutlet.setImage(imagePro, for: .normal)
            loginBtnOutlet.tintColor = Constants.Color.rougeDeClaudius


            return
        }
        loginBtnOutlet.setImage(nil, for: .normal)
        loginBtnOutlet.setTitle("Login", for: .normal)
        loginBtnOutlet.setTitleColor(UIColor.white, for: .normal)
        loginBtnOutlet.tintColor = Constants.Color.rougeDeClaudius

        
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
