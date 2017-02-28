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


class DetailEventViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var favBtn: UIButton!
    var eventId:String?
    var event :FBEvent?
    var isFav :Bool = false

    var tabApero = [Apero]()
    var selected:Apero? = nil
    @IBOutlet weak var styleMusical: UILabel!
    
    @IBOutlet weak var listeAperoView: UIView!
    @IBOutlet weak var addApero: UIButton!
    @IBOutlet weak var eventIdLabel: UILabel!

    @IBOutlet weak var coverimage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var calendarImageView: UIImageView!
    //@IBOutlet weak var listeAperosAssocie: UILabel!
    @IBOutlet weak var addAperosBtn: UILabel!
    @IBOutlet weak var eventname: UILabel!
    @IBOutlet weak var eventDescriptino: UILabel!

    @IBOutlet weak var inviteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addApero.layer.borderWidth = 0.5
        addApero.layer.borderColor = UIColor.white.cgColor
        
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        
        //print( Constants.Aperos.tabEApero)
        
        for app in tabApero {
            app.observeApero()
        }


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
            //print(eventId)
            isSaveEventAsFav()
            getFBEventInfo()
            
            initView()
            getStyle()
            
        
        }
        //initView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initView(){
        inviteTableView.backgroundColor = UIColor.clear
        event?.observeEvent()
        //DATA INCRMENTS
        dateLabel.text = event?.date
        placeLabel.text = event?.place
        
        //Date View
        //dateView.layer.borderWidth = 1.0
        dateView.tintColor = Constants.Color.jauneDeClaudius
        //dateView.layer.borderColor =  Constants.Color.jauneDeClaudius.cgColor
        dateView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        calendarImageView.tintColor = Constants.Color.jauneDeClaudius
        
        //listeAperosAssocie
        var temptab = [Apero]()
        //var i = 0

        
        //print( Constants.Aperos.tabEApero)
        for id in (self.event?.tabAperoId)! {
          //print(id)
            for apero in Constants.Aperos.tabEApero{
                if id == apero.id{
                    apero.observeApero()
                    self.event?.saveAperoToEvent(apero: apero)
                    
                    temptab.append(apero)
                }
                
            }
            

        }
        tabApero = temptab
        inviteTableView.reloadData()
    
    }
    func getStyle(){
        if !(eventDescriptino.text?.isEmpty)!{
            let des:String = (eventDescriptino.text)!
            print(des)
            if (des.lowercased().contains("hip-hop")){
                styleMusical.text = "hip-hop"
            }else if (des.lowercased().contains("rap")){
                styleMusical.text = "Rap"
            }else if (des.lowercased().contains("techno")){
                styleMusical.text = "Techno"
            }else if (des.lowercased().contains("trance")){
                styleMusical.text = "Trance"
            }else if (des.lowercased().contains("acid")){
                styleMusical.text = "Acid"
            }else if (des.lowercased().contains("house")){
                styleMusical.text = "House"
            }else{
                styleMusical.text = "Autre"
            }

        
        }else{
            styleMusical.text = "Autre"
        }
        
    }
    
    
    //-------------------------------------
    // MARK: - TableVIew Handler
    //-------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tabApero.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AperoTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "AperoCell", for: indexPath) as UITableViewCell as! AperoTableViewCell
        cell.TitleLabel?.text = tabApero[indexPath.row].name
        let adress: String = self.tabApero[indexPath.row].adresse!
        let nb: String = self.tabApero[indexPath.row].nbInvite
        if !adress.isEmpty {
            cell.PalceLabel?.text = adress
        }
        if !nb.isEmpty  {
            cell.nbRestantLabel?.text = nb
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.selected = self.tabApero[indexPath.row]
        showApero()
        
    
    }
    
    //-------------------------------------
    func showApero(){
        performSegue(withIdentifier: "showAperoSegue", sender: selected)
        selected = nil
    
    }
    
    
    
    
    
    
    func getFBEventInfo(){
        
        if (FBSDKAccessToken.current()) != nil , Constants.Users.user != nil {
            
            let graph = eventId
            
            FBSDKGraphRequest.init(graphPath: graph,
                                   parameters: ["fields": "id,place,name,start_time,ticket_uri,interested_count,description,cover",]).start { (connection, result, error) in
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
                                    self.getStyle()
                                    
                                            let eventticket = resultat?["ticket_uri"] as? String
                                            let eventInteret = resultat?["interested_count"] as? String
                                            //print(eventplace)
                                    
                                            if let cover = (resultat?["cover"] as? NSDictionary)?["source"]{
                                                var coverUrl = cover as?  String
                                                print(coverUrl)
                                                
                                                let url = NSURL(string: coverUrl!)
                                                let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                                                self.coverimage.image = UIImage(data: data! as Data)
                                                
                                            }
                                   // self.inviteTableView.reloadData()
                                            
                                            
                                        
                                    
                                    
                                    
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
            destVC.eventId = event?.id
            
        }
        
        if segue.identifier == "showAperoSegue" {
            
            let destVC = segue.destination as! AperoPageViewController
            destVC.apero = sender as? Apero
            
        }

        }
    
        
        
    }



