//
//  detailEventViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 14/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase


class DetailEventViewController: UIViewController {
    
    @IBOutlet weak var favBtn: UIButton!
    var eventId:String?
    var event :FBEvent?
    var isFav :Bool = false
    
    @IBOutlet weak var addApero: UIButton!
    @IBOutlet weak var eventIdLabel: UILabel!

    @IBOutlet weak var listeAperosAssocie: UILabel!
    @IBOutlet weak var addAperosBtn: UILabel!
    @IBOutlet weak var eventname: UILabel!
    @IBOutlet weak var eventDescriptino: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addApero.layer.borderWidth = 0.5
        addApero.layer.borderColor = UIColor.white.cgColor
        

        for event in Constants.Events.tabEvent{
        
            if event.id == eventId{
            
                self.event = event
                self.event?.observeEvent()
                Helper.getBDDAperos()
                return
                
            }
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if eventId != nil {
            self.event?.observeEvent()
            print(eventId) 
            isSaveEventAsFav()
            getFBEventInfo()
            eventIdLabel.text = eventId
            
            initView()
            
        }
        //initView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initView(){
        //listeAperosAssocie
        
        //recuperation des Apéros asso a l'event AFINIR MENES
        var listeEvent:String=""
        //print( Constants.Aperos.tabEApero)
        for id in (self.event?.tabAperoId)! {
          print(id)
            for apero in Constants.Aperos.tabEApero{
                if id == apero.id{
                    
                    listeEvent += apero.name!
                    listeEvent += "\n"
                
                }
                
            }
            

        }
        
        listeAperosAssocie.text? = listeEvent
    
    
    }
    func getFBEventInfo(){
        
        if (FBSDKAccessToken.current()) != nil , Constants.Users.user != nil {
            
            let graph = eventId
            
            FBSDKGraphRequest.init(graphPath: graph,
                                   parameters: ["fields": "id,place,name,start_time,ticket_uri,interested_count,description",]).start { (connection, result, error) in
                                    //print("Wesh")
                                    print(result)
                                    let resultat = result as? NSDictionary
                                                                            
                                            // Access event data
                                            let eventplace = resultat?["place"] as? NSDictionary
                                            let eventname = resultat?["name"] as? String
                                    self.eventname.text = eventname
                                            let eventdate = resultat?["start_time"] as? String
                                            let eventDescription = resultat?["description"] as? String
                                    self.eventDescriptino.text = eventDescription
                                            let eventticket = resultat?["ticket_uri"] as? String
                                            let eventInteret = resultat?["interested_count"] as? String
                                            print(eventplace)
                                            
                                            
                                        
                                    
                                    
                                    
        }
            
            
    }
        
        
   
    }
    @IBAction func addAperoBtn(_ sender: Any) {
        performSegue(withIdentifier: "aperoSegue2", sender: nil)

        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        
        isSaveEventAsFav()
       
        
        if isFav == false {

            Constants.Users.user?.saveEventAsFav(event: event!)
        }else{

            Constants.Users.user?.deleteEventAsFav(event: event!)
        }
        Constants.Users.user?.getEventAsFav()


    }
    func isSaveEventAsFav(){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/").child("users").child((Constants.Users.user?.id!)!)
        //let value = ["nom": event.name , "date":event.date]
        let favReference = ref.child("EventFav").child(eventId!)
        favReference.observe(.value, with: { (snapshot) in
            print(snapshot)
            
            if snapshot.value  is NSNull{
                self.isFav = false
                self.favBtn.setImage(UIImage(named: "addFavori"), for: UIControlState.normal)
            }else{
                self.isFav = true
                 self.favBtn.setImage(UIImage(named: "Favoris"), for: UIControlState.normal)
            }
            
        })
    
        
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
    // MARK: - Segue handler
    //-------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "aperoSegue2" {
            print("new apéros")
            let destVC = segue.destination as! AddAperoViewController
            if eventIdLabel.text != nil {
                destVC.evenId = eventIdLabel.text
            }
            
        }

        }
    
        
        
    }



