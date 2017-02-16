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

class AddAperoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var descrField: UITextField!
    @IBOutlet var eventField: UITextField!
    @IBOutlet var nbGuestField: UITextField!
    @IBOutlet var adressField: UITextField!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var startField: UITextField!
    @IBOutlet var endField: UITextField!
    @IBOutlet var cpField: UITextField!
    
    var ref : FIRDatabaseReference!
    var evenId: String?
    var user:User?
    var guests = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var guestPicker = UIPickerView()
    let timePickerS = UIDatePicker()
    let timePickerE = UIDatePicker()

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        guestPicker.delegate = self
        guestPicker.dataSource = self
        
        nbGuestField.inputView = guestPicker
        
        createTimePicker()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        view.addGestureRecognizer(tap)


        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return guests.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return guests[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nbGuestField.text = guests[row]
        self.view.endEditing(false)
    }
    
    func createTimePicker(){
        timePickerS.datePickerMode = .time
        timePickerE.datePickerMode = .time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (donePressed))
        toolbar.setItems([doneButton], animated: false)
        startField.inputAccessoryView = toolbar
        endField.inputAccessoryView = toolbar
        startField.inputView = timePickerS
        endField.inputView = timePickerE
    }
    
    func donePressed(){
        let formatTime = DateFormatter()
        formatTime.dateStyle = .none
        formatTime.timeStyle = .short
        startField.text = formatTime.string(from: timePickerS.date)
        endField.text = formatTime.string(from: timePickerE.date)
        self.view.endEditing(true)
    }
    
    @IBAction func AddApero(_ sender: Any) {
        let title = titleField.text!
        let decr = descrField.text
        let event = eventField.text
        let nbGuest = nbGuestField.text
        let adress = adressField.text
        let start = startField.text
        let end = endField.text
        let cp = cpField.text
        let fbid = Constants.Users.user?.fbId
        titleField.text = ""
        descrField.text = ""
        eventField.text = ""
        nbGuestField.text = ""
        adressField.text = ""
        startField.text = ""
        endField.text = ""
        cpField.text = ""
        
        ref = FIRDatabase.database().reference()
        
        let apero  =  ["title": title, "description": decr, "event": event, "nbGuest": nbGuest, "address":adress, "fbid": fbid, "commence a": start, "fini a": end, "cp": cp]
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
