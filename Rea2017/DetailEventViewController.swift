//
//  detailEventViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 14/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class DetailEventViewController: UIViewController {
    
    var eventId:String?
    var event :FBEvent?
    
    @IBOutlet weak var eventIdLabel: UILabel!

    @IBOutlet weak var addAperosBtn: UILabel!
    @IBOutlet weak var eventname: UILabel!
    @IBOutlet weak var eventDescriptino: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if eventId != nil {
            print(eventId)
            getFBEventInfo()
            eventIdLabel.text = eventId
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



