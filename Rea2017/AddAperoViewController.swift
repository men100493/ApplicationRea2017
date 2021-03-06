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
import MapKit

class AddAperoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var noSmoking: UIButton!
    @IBOutlet var descrField: UITextField!
    @IBOutlet var eventField: UITextField!
    @IBOutlet var nbGuestField: UITextField!
    @IBOutlet var adressField: UITextField!
    //@IBOutlet var titleField: UITextField!
    @IBOutlet var startField: UITextField!
    @IBOutlet var endField: UITextField!
    //@IBOutlet var cpField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var BoissView: UIView!
    @IBOutlet weak var NourrView: UIView!
    @IBOutlet weak var ListeBoiss: UILabel!
    @IBOutlet weak var ListeNour: UILabel!
    @IBOutlet weak var listeCoursesView: UIView!
    @IBOutlet weak var dateEventField: UITextField!
    
    @IBOutlet weak var lieuEventField: UITextField!
    
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var nomHoteLabel: UILabel!
    var ref : FIRDatabaseReference!
    var eventId: String?
    var event: FBEvent?
    var user:User?
    var guests = ["1", "2", "3", "4", "5", "6", "7", "8", "9","10","11"]
    let tabEvent = Constants.Events.tabEvent
    var guestPicker = UIPickerView()
    var eventPicker = UIPickerView()
    let timePickerS = UIDatePicker()
    let timePickerE = UIDatePicker()

    
    var vinVal:Int = 0
    var biereVal:Int = 0
    var alcFortVal:Int = 0
    var pizzaVal:Int = 0
    var chipsVal:Int = 0
    var platVal:Int = 0
    
    var smoke:Bool?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.smoke = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = Constants.Users.user
        guestPicker.delegate = self
        guestPicker.dataSource = self
        eventPicker.delegate = self
        eventPicker.dataSource = self
        self.addBtn.isEnabled = false
        
        eventField.inputView = eventPicker
        nbGuestField.inputView = guestPicker
        
        createTimePicker()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        let tapCourse: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (goToCourseVC))
        listeCoursesView.addGestureRecognizer(tapCourse)
        view.addGestureRecognizer(tap)


        // Do any additional setup after loading the view.
    }
    
    func goToCourseVC(){
       //print("Wesh")
        performSegue(withIdentifier: "listeCourseSegue", sender: nil)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if eventId != nil {
            
            for event in Constants.Events.tabEvent{
                if event.id == eventId{
                    eventField.text = event.name
                
                }
            }
            //setContent()
            
            
        }
        
        setContent()
    }
    
    func setContent(){
        if let pictureFB = user?.photoProfilUrl {
            let url = NSURL(string: pictureFB)
            let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
            profilImageView.image = UIImage(data: data! as Data)
            profilImageView.layer.cornerRadius = 40
            profilImageView.layer.masksToBounds = true
            //profilImageView.layer.borderWidth = 0.3
            //profilImageView.layer.borderColor =  UIColor.white.cgColor
            
        }
        
        
        let coverUrl = event?.coverUrlFB
        if coverUrl != nil {
            let url = NSURL(string: coverUrl!)
            let data = NSData(contentsOf: url! as URL)
            eventImageView.image = UIImage(data: data! as Data)
        }
        
        nomHoteLabel.text = (Constants.Users.user?.pnom)! + " " +  (Constants.Users.user?.nom)!
        
        BoissView.layer.borderWidth = 1.0
        BoissView.layer.borderColor = UIColor(ciColor: .black()).cgColor
        NourrView.layer.borderWidth = 1.0
        NourrView.layer.borderColor = UIColor(ciColor: .black()).cgColor


    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == guestPicker {
            return guests.count
        }else{
            return tabEvent.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == guestPicker {
            return guests[row]
        }else{
            return tabEvent[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == guestPicker {
            nbGuestField.text = guests[row]
        }else{
             eventField.text = tabEvent[row].name
            let date:String = tabEvent[row].date!
            dateEventField.text = date
            lieuEventField.text  = tabEvent[row].place
             eventId = tabEvent[row].id
            setContent()
        }
        if (!(eventField.text?.isEmpty)! && !(nbGuestField.text?.isEmpty)! ){
            addBtn.isEnabled = true
        }else{
            addBtn.isEnabled = false
        }
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
        setContent()
        formatTime.dateStyle = .none
        formatTime.timeStyle = .short
        startField.text = formatTime.string(from: timePickerS.date)
        endField.text = formatTime.string(from: timePickerE.date)
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func AddApero(_ sender: Any) {
        let id = NSUUID().uuidString
        let title = (Constants.Users.user?.pnom)! + " " + (Constants.Users.user?.nom)!
        let decr = descrField.text
        let eventid = eventId
        let nbGuest = nbGuestField.text!
        let adress = adressField.text!
        let start = startField.text
        let end = endField.text
        
        
        if !title.isEmpty, !nbGuest.isEmpty , !(adress.isEmpty), !(eventid?.isEmpty)!{
        
            //titleField.text = ""
            descrField.text = ""
            eventField.text = ""
            nbGuestField.text = ""
            adressField.text = ""
            startField.text = ""
            endField.text = ""
            //cpField.text = ""
        
//                ref = FIRDatabase.database().reference()
        
//            let apero  =  ["id":id, "title": title, "description": decr, "event": event, "nbGuest": nbGuest, "address":adress, "commence a": start, "fini a": end, "cp": cp]
//            ref.child("Apero").child(id).setValue(apero)
            
            //let aperoForTab = Apero(id: id, name: title, nbInvite: nbGuest!, descrip: decr!)
            let aperosTab = Apero(id: id, name: title, nbInvite: nbGuest, descrip: decr!, eventFB: eventid!, adresse: adress, startTime: start!, endTime: end!)
            
            
            if aperosTab != nil {
                aperosTab.addCourse(nom: "vin", value: vinVal)
                aperosTab.addCourse(nom: "biere", value: biereVal)
                aperosTab.addCourse(nom: "alcoolF", value: alcFortVal)
                aperosTab.addCourse(nom: "pizza", value: pizzaVal)
                aperosTab.addCourse(nom: "chips", value: chipsVal)
                aperosTab.addCourse(nom: "plats", value: platVal)

            }
            if (Constants.Events.tabEvent.count != 0 ){
                if let event = Constants.Events.tabEvent.first(where: { $0.id == eventid! }){
                    
                    aperosTab.saveAperoToBDD()
                    //aperosTab.saveEventToApero(event: event)
                    
                    event.saveAperoToEvent(apero: aperosTab)
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
 }


    @IBAction func noSmokingAction(_ sender: Any) {
        if smoke! {
            noSmoking.alpha = 0.3
            smoke = false
        
        } else {
            noSmoking.alpha = 1.0
            smoke = true
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "listeCourseSegue" {
            print("new Courses")
            let destVC = segue.destination as! ListeCoursesViewController
            
            destVC.vinVal = self.vinVal
            destVC.biereVal = self.biereVal
            destVC.alcFortVal = self.alcFortVal
            destVC.pizzaVal = self.pizzaVal
            destVC.chipsVal = self.chipsVal
            destVC.platVal = self.platVal
            
            
            
            
        }
        
    }
    @IBAction func unwindFromListeCourse(sender: UIStoryboardSegue) {
        
        if sender.source is ListeCoursesViewController {
            
            print("BAck From Lsite COurse")
            
            let srcVC = sender.source as! ListeCoursesViewController
            self.vinVal = srcVC.vinVal
            self.biereVal = srcVC.biereVal
            self.alcFortVal = srcVC.alcFortVal
            self.pizzaVal = srcVC.pizzaVal
            self.chipsVal  = srcVC.chipsVal
            self.platVal  = srcVC.platVal
            
            
            var boiss:String = NSString(format:"%i", self.vinVal) as String + " X Bouteille de vin\n"

            boiss += (NSString(format:"%i", self.biereVal) as String)  + " X Bouteille de bière\n"
            boiss += (NSString(format:"%i", self.alcFortVal) as String)  + " X Bouteille d'alcool" as String
            print (boiss)
            self.ListeBoiss.text = NSString(format:"%@", boiss) as String
            
            var nour:String = NSString(format:"%i", pizzaVal) as String + " X Pizza\n"
            
            nour += (NSString(format:"%i", chipsVal) as String) + " X Paquets de chips\n" as String
            nour += (NSString(format:"%i", platVal) as String) + " X Plats\n" as String
            print(nour)
            
            self.ListeNour.text = NSString(format:"%@", nour) as String

        }
    }

}
