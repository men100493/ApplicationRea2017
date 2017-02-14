//
//  AddAperoViewController.swift
//  Rea2017
//
//  Created by Camille RICHY on 12/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddAperoViewController: UIViewController {
    
    
    @IBOutlet var descrField: UITextField!
    @IBOutlet var eventField: UITextField!
    @IBOutlet var nbGuestField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var titleField: UITextField!
    var ref : FIRDatabaseReference!
    var evenId: String?
    var user:User?

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if evenId != nil {
            eventField.text = evenId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddApero(_ sender: Any) {
        let title = titleField.text!
        let decr = descrField.text
        let event = eventField.text
        let nbGuest = nbGuestField.text
        let adress = adressField.text
        let fbid = Constants.Users.user?.fbId
        titleField.text = ""
        descrField.text = ""
        eventField.text = ""
        nbGuestField.text = ""
        adressField.text = ""
        
        ref = FIRDatabase.database().reference()
        
        let apero  =  ["title": title, "description": decr, "event": event, "nbGuest": nbGuest, "address":adress, "fbid": fbid]
        ref.child("Apero").childByAutoId().setValue(apero)
        
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
