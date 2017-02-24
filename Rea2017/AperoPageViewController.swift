//
//  AperoPageViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 15/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class AperoPageViewController: UIViewController ,UITextFieldDelegate ,UITableViewDelegate , UITableViewDataSource{

    //@IBOutlet weak var UserPresent: UILabel!
    @IBOutlet weak var predictiveTableView: UITableView!
    @IBOutlet weak var userAdd: UITextField!

    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var addUserInView: UIButton!
    @IBOutlet weak var addUserBtn: UIButton!
    @IBOutlet weak var addUserView: UIView!
    @IBOutlet weak var EventAperoLabel: UILabel!
    @IBOutlet weak var AperoNameLabel: UILabel!
    
    @IBOutlet weak var nbInvitLabel: UILabel!
    var apero : Apero?
    var tabPreditive = Constants.Users.tabUser
    var autoCompletename = [String]()
    var userSeleted: User?
    var tabInvite = [User]()
    var eventId: FBEvent?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addUserInView.isEnabled = false
        addUserBtn.isHidden = true
        addUserView.isHidden = true
        view.bringSubview(toFront: addUserView)
        predictiveTableView.isHidden = true
        userAdd.delegate = self
        predictiveTableView.delegate = self
        print( tabPreditive.count)
        if self.apero != nil {
            self.apero?.observeApero()
            if ((self.apero?.tabInvite) != nil){
                tabInvite = (self.apero?.tabInvite)!
                userPart()
            }
            if apero?.userHost?.id == Constants.Users.user?.id{
                addUserBtn.isHidden = false
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.apero != nil {
            //self.apero?.observeApero()
            userPart()
            tabInvite = (self.apero?.tabInvite)!

            AperoNameLabel.text = apero?.name
            EventAperoLabel.text = apero?.eventFb
            nbInvitLabel.text = apero?.nbInvite
            for event in Constants.Events.tabEvent {
                if event.id == self.apero?.eventFb {
                    self.eventId = event
                    EventAperoLabel.text =  event.name
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToEventPage))
                    EventAperoLabel.isUserInteractionEnabled = true
                    EventAperoLabel.addGestureRecognizer(tap)
                    
                }
            }
            
            
        }
    }
    
    func goToEventPage(){
          performSegue(withIdentifier: "showEventSegue", sender: self.eventId)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "predictiveCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.tabPreditive[indexPath.row].nom! + " " + self.tabPreditive[indexPath.row].pnom!
        

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabPreditive.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = self.tabPreditive[indexPath.row].nom! + " " + self.tabPreditive[indexPath.row].pnom!
        userAdd.text = selected
        userSeleted = self.tabPreditive[indexPath.row]
        tabPreditive = Constants.Users.tabUser
        predictiveTableView.isHidden = true
        userAdd.isSelected = false
        self.userAdd.resignFirstResponder()
        self.predictiveTableView.reloadData()
        
        
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userAdd.resignFirstResponder()
        predictiveTableView.isHidden = true
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.predictiveTableView.isHidden = false
        self.addUserInView.isEnabled = true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {

        
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
            self.tabPreditive.removeAll(keepingCapacity: false)
            for user in Constants.Users.tabUser
            {
                let myString = user.nom as NSString!
                let myString2 = user.pnom as NSString!
                //let substringRange :NSRange! = myString!.range(of: substring)
                let sub = myString?.substring(to: length)
                let sub2 = myString2?.substring(to: length)
                if (sub?.lowercased()  == substring.lowercased()) || (sub2?.lowercased()  == substring.lowercased())
                {
                tabPreditive.append(user)
            }
            }
        
        predictiveTableView.reloadData()
        }else{
            self.tabPreditive = Constants.Users.tabUser
            predictiveTableView.reloadData()
        }
    }

    @IBAction func AddUserToEvent(_ sender: Any) {
        self.userAdd.resignFirstResponder()
        predictiveTableView.isHidden = true
        userAdd.isSelected = false
        
        if (apero?.name.isEmpty)! || (apero?.id.isEmpty)! || (apero?.eventFb?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Problème", message:
                "Votre Apero n'est pas valide dsl 'no body is perfect' ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        
        }else{
            
            if (userAdd.text?.isEmpty)! {
                
                
                let alertController = UIAlertController(title: "Problème", message:
                    "Le champ n'a pas été remplis", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                
            }else if userSeleted?.id == apero?.userHost?.id{
                let alertController = UIAlertController(title: "Problème", message:
                    "Tu es hote de cette soirée tu ne peux pas t'inviter", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }else{
                var bool = false
                for user in (apero?.tabInvite)!{
                    if userSeleted?.id! == user.id{
                        
                        bool = true
                    }
                    
                }
                
                if bool{
                    
                    let alertController = UIAlertController(title: "Problème", message:
                        "utilisateur déja invité", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }else{
                    apero?.addUser(user: userSeleted!)
                    let alertController = UIAlertController(title: "Ajout utilisateur", message:
                        "Utilisateur Ajouté", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    apero?.observeApero()
                    userAdd.text =  nil
                    view.endEditing(true)
                    //tabInvite = (self.apero?.tabInvite)!
                    userPart()
                    addUserView.isHidden = true
                    self.userAdd.resignFirstResponder()
                    predictiveTableView.isHidden = true
                }
                
                
                //AZZZYYYY j'ai la flème
            }
        
        }

        userPart()

    }
    
    func userPart(){
        //var inviteText:String = ""
        apero?.observeApero()

        tabInvite = (self.apero?.tabInvite)!
        var i = 0
        
        for invite in tabInvite {
            let inviteText: String = invite.nom!
            
            let buttonUser = UIButton(frame: CGRect(x: 20+(100*i), y: 10, width: 75, height: 30))
            buttonUser.setTitle(inviteText, for: .normal)
            buttonUser.tag = i
            buttonUser.backgroundColor = UIColor(cgColor: UIColor.black.cgColor)
            buttonUser.addTarget(self, action: #selector(self.showUserProfile), for: UIControlEvents.touchUpInside)
            
            self.userView.addSubview(buttonUser)
            i += 1
        }
        //UserPresent.text = inviteText
    
    }
    
    func showUserProfile(sender:UIButton!) {
        let title = sender.title(for: .normal)
        //print(title)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : OtherUserViewController = mainStoryboard.instantiateViewController(withIdentifier: "OtherUserVC") as! OtherUserViewController
        vc.otherUser = self.tabInvite[sender.tag]
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addUserToEvent(_ sender: Any) {
         addUserView.isHidden = false
        self.addUserInView.isEnabled = false
        self.predictiveTableView.isHidden  = true
        
        
    }
    @IBAction func addUserQuit(_ sender: Any) {
         addUserView.isHidden = true
        self.addUserInView.isEnabled = false
        self.predictiveTableView.isHidden  = true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindFromOtherUser(sender: UIStoryboardSegue) {
        
        if sender.source is OtherUserViewController {
            
            print("BAck From other Profile")
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        
        if segue.identifier == "showEventSegue" {
            
            let destVC = segue.destination as! DetailEventViewController
            destVC.event = self.eventId
            destVC.eventId = self.eventId?.id
        }
        
    }
    
    
    
}




