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
        let id = NSUUID().uuidString
        let title = titleField.text!
        let decr = descrField.text
        let eventid = eventField.text
        let nbGuest = nbGuestField.text!
        let adress = adressField.text
        let start = startField.text
        let end = endField.text
        let cp = cpField.text
        
        
        if !title.isEmpty, ((nbGuest != nil)) , !(adress?.isEmpty)!, !(eventid?.isEmpty)!{
        
            titleField.text = ""
            descrField.text = ""
            eventField.text = ""
            nbGuestField.text = ""
            adressField.text = ""
            startField.text = ""
            endField.text = ""
            cpField.text = ""
        
//                ref = FIRDatabase.database().reference()
        
//            let apero  =  ["id":id, "title": title, "description": decr, "event": event, "nbGuest": nbGuest, "address":adress, "commence a": start, "fini a": end, "cp": cp]
//            ref.child("Apero").child(id).setValue(apero)
            
            //let aperoForTab = Apero(id: id, name: title, nbInvite: nbGuest!, descrip: decr!)
            let aperosTab = Apero(id: id, name: title, nbInvite: nbGuest, descrip: decr!, eventFB: eventid!, adresse: adress!, startTime: start!, endTime: end!, cp: cp!)
            
            if (Constants.Events.tabEvent.count != 0 ){
                if let event = Constants.Events.tabEvent.first(where: { $0.id == eventid! }){
                    
                    aperosTab.saveAperoToBDD()
                    aperosTab.saveEventToApero(event: event)
                    event.tabAperoId.append(aperosTab.id)
                    
            }
            Constants.Aperos.tabEApero.append(aperosTab)
            self.dismiss(animated: true, completion: nil)
                
        }
        
        }else if((eventid?.isEmpty)!){
            
            let alertController = UIAlertController(title: "Problème", message:
                "Genre tu veux faire un Apero sans evenement ... poche à bière !", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }else{
            let alertController = UIAlertController(title: "Problème", message:
                "Un champ n'a pas été remplis", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
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
}
