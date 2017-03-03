//
//  ConfigProfilViewController.swift
//  Rea2017
//
//  Created by Camille RICHY on 15/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import Firebase


var ref : FIRDatabaseReference!
var evenId: String?
var user:User?

class ConfigProfilViewController: UIViewController {

    @IBOutlet var surnomField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var cpField: UITextField!
    @IBOutlet var musicField: UITextField!
    @IBOutlet var phoneField: UITextField!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        view.addGestureRecognizer(tap)
        let nom = (user?.nom)! + " " + (user?.pnom)!
        nameLabel.text = nom
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func update(_ sender: Any) {
        let surnom = surnomField.text!
        let adress = adressField.text
        let cp = cpField.text
        let music = musicField.text
        let phone = phoneField.text
        let fbid = Constants.Users.user?.fbId
        
        surnomField.text = ""
        adressField.text = ""
        cpField.text = ""
        musicField.text = ""
        phoneField.text = ""
        
        
        ref = FIRDatabase.database().reference().child("users/" + fbid!)
        
        let user  =  ["surnom": surnom, "adress": adress, "cp": cp, "music": music, "phone":phone]
        ref.updateChildValues(user)
    }
    
    
}
