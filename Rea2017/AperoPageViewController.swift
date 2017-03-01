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
    @IBOutlet weak var placeAperoLabel: UILabel!

    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var addUserInView: UIButton!
    @IBOutlet weak var addUserBtn: UIButton!
    @IBOutlet weak var addUserView: UIView!
    
    @IBOutlet weak var avisHoteLabel: UILabel!
    @IBOutlet weak var ageHoteLabel: UILabel!
    @IBOutlet weak var AperoNameLabel: UILabel!
    @IBOutlet weak var listeTitreLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var placeLeftView: UIView!
    @IBOutlet weak var participantView: UIView!
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var descriptionAperoLabel: UILabel!
    @IBOutlet weak var dateEventLabel: UILabel!
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
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.apero != nil {
            //self.apero?.observeApero()
            userPart()
            tabInvite = (self.apero?.tabInvite)!
            setContent()
            scrollView.contentSize.height = 900
            

            
            
        }
    }
    
    func setContent(){
        print(Constants.Users.user?.id)
//        if apero?.userHostid == Constants.Users.user?.id{
//            addUserBtn.isHidden = false
//        }
//        
        for user in Constants.Users.tabUser {
            
        
            if user.id == apero?.userHostid {
                user.getFBUptade()
                AperoNameLabel.text = user.pnom! + " " + user.nom!
                ageHoteLabel.text = user.naiss
                let naiss = user.naiss?.components(separatedBy: "/")
                let date = Date()
                let calendar = Calendar.current
                
                let yearAct = calendar.component(.year, from: date)
                let age = Int(yearAct) - Int((naiss?[2])!)!
                ageHoteLabel.text = String(age) + " ans"
                listeTitreLabel.text = "La liste de " +  user.pnom!
                
                if let pictureFB = user.photoProfilUrl {
                    let url = NSURL(string: pictureFB)
                    let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    profilImageView.image = UIImage(data: data! as Data)
                    profilImageView.layer.cornerRadius = 40
                    profilImageView.layer.masksToBounds = true
                    //profilImageView.layer.borderWidth = 0.3
                    //profilImageView.layer.borderColor =  UIColor.white.cgColor
                
                }
                
                
            }
        }
        
        
        
        placeAperoLabel.text = apero?.adresse

        descriptionAperoLabel.text = apero?.descrip
        //EventAperoLabel.text = apero?.eventFb
        if ((apero?.nbInvite)! != nil){
            nbInvitLabel.text = (apero?.nbInvite)! + " Places"
            
            if let nb = Int ((apero?.nbInvite)!){
                var y = 0
                var x = 10
                for i in 0 ... nb-1 {
                    
                    if i%3 == 0{
                        y = y + 40
                        x = 10
                    }else{
                        x = x + 40
                    }
                    //placeLeftview
                    
                    let userImage = UIImage(named: "user")
                    let userView = UIImageView(image: userImage)
                    userView.frame = CGRect(x: x, y: y, width: 30, height: 30)

                    let tap = UITapGestureRecognizer(target: self, action: #selector(addUserTapped))
                    userView.addGestureRecognizer(tap)
                    userView.isUserInteractionEnabled = true
                    self.placeLeftView.addSubview(userView)
                    
                   

                }
            
            }
            
            
        }
        
        
        
        for event in Constants.Events.tabEvent {
            if event.id == self.apero?.eventFb {
                self.eventId = event
                //Recuperer l'image de fond
                //Date de l'event$
                let d = event.date
                let da = d?.components(separatedBy: "T")
                //print(date?[0])
                
                let date = da?[0].components(separatedBy: "-")
                //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let j = date?[2]
                var m = date?[1]
                let a = date?[0]
                
                
                switch Int(m!) {
                case _ where  Int(m!) == 1:
                    m = "janvier"
                case _ where  Int(m!) == 2:
                    m = "fevrier"
                case _ where  Int(m!) == 3:
                    m = "mars"
                case _ where  Int(m!) == 4:
                    m = "avril"
            
                default:
                    m = "décembre"
                }

                dateEventLabel.text = j! + " " + m! + " " +  a!
                let coverUrl = event.coverUrlFB
                if coverUrl != nil {
                    let url = NSURL(string: coverUrl!)
                    let data = NSData(contentsOf: url! as URL)
                    eventImageView.image = UIImage(data: data! as Data)
                }
                
//                EventAperoLabel.text =  event.name
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToEventPage))
//                EventAperoLabel.isUserInteractionEnabled = true
//                EventAperoLabel.addGestureRecognizer(tap)
                
            }
        }

    
    }
    func addUserTapped(){
        
        if apero?.userHostid == Constants.Users.user?.id{
            self.addUserBtn.sendActions(for: .touchUpInside)
            
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
                
                
            }else if userSeleted?.id == apero?.userHostid{
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
                    alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default,handler: addUserHandler))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    userAdd.text =  nil
                    view.endEditing(true)
                    //tabInvite = (self.apero?.tabInvite)!
                    
                    addUserView.isHidden = true
                    self.userAdd.resignFirstResponder()
                    predictiveTableView.isHidden = true
                    
                }
                        
                //AZZZYYYY j'ai la flème
            }
        
        }


    }
    
    func addUserHandler(alert: UIAlertAction!){
        
        apero?.observeApero()
        setContent()
        userPart()
    
    
    }
    
    func userPart(){
        //var inviteText:String = ""
        apero?.observeApero()

        tabInvite = (self.apero?.tabInvite)!
        var i = 0
        
        for invite in tabInvite {
            let inviteText: String = invite.nom!
            if  invite.photoProfilUrl != nil {
                let photoInvite:String = invite.photoProfilUrl!
                let url = NSURL(string: photoInvite)
                let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                //UIImage(data: data! as Data)
                let image = UIImage(data: data! as Data)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 20+(100*i), y: 10, width: 80, height: 80)
                imageView.layer.cornerRadius = 40
                imageView.layer.masksToBounds = true
                imageView.layer.borderWidth = 0.3
                imageView.layer.borderColor =  UIColor.white.cgColor
                self.participantView.addSubview(imageView)
            
            }
            


            let buttonUser = UIButton(frame: CGRect(x: 20+(100*i), y: 80, width: 80, height: 20))
            buttonUser.setTitle(inviteText, for: .normal)
            buttonUser.tag = i
            buttonUser.backgroundColor = UIColor(cgColor: UIColor.black.cgColor)
            buttonUser.addTarget(self, action: #selector(self.showUserProfile), for: UIControlEvents.touchUpInside)
            
            self.participantView.addSubview(buttonUser)
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




