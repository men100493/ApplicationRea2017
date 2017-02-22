//
//  SearchViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate{
        @IBOutlet weak var loginBtnOutlet: UIButton!

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // ADD THE UISearchController
    var searchController:UISearchController!
    
    
    var user :User?
    var eventChoose :FBEvent?
    var aperoChoose :Apero?
    
    //create two arrays
    var searchArray = [String]()       //array of all value
    var searchArrayid = [String]()
    var filteredsearch = [String]()    //array of filtered search
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Constants.Users.user
        Helper.initViewController()
        Helper.getFBEvents()
        Helper.getBDDAperos()
        //searchTableView.delegate = self
        //searchTableView.dataSource = self
        // Do any additional setup after loading the view.
         initHomeViewController()
        Helper.getBDDEvents()
        Helper.getBDDAperos()
        
        for event in Constants.Events.tabEvent {
            self.searchArray.append(event.name!)
            self.searchArrayid.append(event.id)
        }
//        for apero in Constants.Aperos.tabEApero{
//            self.searchArray.append(apero.name!)
//            self.searchArrayid.append(apero.id)
//        }
        
        
        //let appDelegate = UIAdelegate as! AppDelegate
        user = Constants.Users.user
        
        
        //Search Controller

        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
        //MAKE SURE YOU RELOAD THE TABLE VIEW LAST
        
        //update table view
        self.searchTableView.reloadData()
        
      
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        initHomeViewController()
    }
    
    
    //-------------------------------------
    // MARK: - UI Search
    //-------------------------------------
    
    // Uupdate searching results
 
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        filterContentForSearchText(searchText: searchText)
        //searchTableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "ALL")
    {
   
        self.filteredsearch = self.searchArray.filter({ (events : String ) -> Bool in
            var categoryMatch = (scope == "ALL")
            
            var stringMatch = events.lowercased().range(of: searchText.lowercased())
            return categoryMatch && (stringMatch != nil)
        })
        searchTableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        self.filterContentForSearchText(searchText: searchString, scope: "ALL")
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText(searchText: self.searchController!.searchBar.text!, scope: "ALL")
        
        return true
        
    }
    
    

    
    //-------------------------------------
    // MARK: - TableView
    //-------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchController.isActive) && searchController.searchBar.text != "" {
            
            return self.filteredsearch.count
            
        }
            
            return self.searchArray.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell")
        
        var event: String
        var id: String
        
        if (searchController.isActive) && searchController.searchBar.text != "" {
            event = self.filteredsearch[indexPath.row]
            let pos = self.searchArray.index(of: event)
            id = self.searchArrayid[pos!]

            
        }else{
            
            event = self.searchArray[indexPath.row]
            id = self.searchArrayid[indexPath.row]

            
        }
        
        cell?.textLabel?.text = event
        cell?.detailTextLabel?.text = id
        
        return cell!
    }
   
//    // method to run when table view cell is tapped
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//       
//       print("Menes Menes mens")
//    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        searchTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        var event: String
        var id: String
        
        if (searchController.isActive && searchController.searchBar.text != "" ){
            
            event = self.filteredsearch[indexPath.row]
            let pos = self.searchArray.index(of: event)
            id = self.searchArrayid[pos!]
            
            
        }else{
            
            event = self.searchArray[indexPath.row]
            id = self.searchArrayid[indexPath.row]
            
        }
        
        print(event ,"----", id)
        
        for event in Constants.Events.tabEvent {
            if event.id == id {
                print("event trouvé")
                self.eventChoose =  event
                performSegue(withIdentifier: "eventSegue", sender: nil)
               
            }
        }
        
        for apero in Constants.Aperos.tabEApero {
            if apero.id == id {
                print("apero trouvé")
                self.aperoChoose = apero
            }
        }
        //performSegue(withIdentifier: "eventSegue", sender: nil)
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
    // MARK: - Boutton => Log in / Profile
    //-------------------------------------
    
    func initHomeViewController(){
        
        let imagePro = UIImage(named: "Profil") as UIImage?
        
        if self.user != nil {
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            loginBtnOutlet.setImage(imagePro, for: .normal)
            
            
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Helper.getUserFBData()
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            //loginBtnOutlet.setTitle("Profil", for: .normal)
            loginBtnOutlet.setTitle("", for: .normal)
            loginBtnOutlet.setImage(imagePro, for: .normal)
            
            
            return
        }
        loginBtnOutlet.setTitle("Login", for: .normal)
        loginBtnOutlet.imageView?.image = nil 
        print("Utilisateur non connecté")
        
        
        
    }
    
   
    @IBAction func LoginOrProfile(_ sender: Any) {
        //self.performSegue(let lg = LoginViewController()
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if loginBtnOutlet.image(for: .normal) != nil  {
            
            let vc : ProfilViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfilVC") as! ProfilViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        else{
            
            let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
            
            
            
            
        }
        
        
    }
    
    
    //-------------------------------------
    // MARK: - Segue handler
    //-------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "eventSegue" {
           
            
            let destVC = segue.destination as! DetailEventViewController
            
            destVC.event =  eventChoose
            destVC.eventId =  eventChoose?.id
            print(eventChoose?.id)
            
            
        }
        
        
        
    }

    
    
    // segue LoginViewController -> HomeViewController
    @IBAction func unwindFromLogin(sender: UIStoryboardSegue) {
        
        if let LoginVC = sender.source as? LoginViewController {
            if LoginVC.user?.isConnectToFireBase() == true , let dataRecieved = LoginVC.user {
                print(dataRecieved )
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                Constants.Users.user =  dataRecieved
                print("BAck From Login")
                
            }
            
        }
    }
    
    @IBAction func unwindFromProfil(sender: UIStoryboardSegue) {
        
        if sender.source is LoginViewController {
            
            print("BAck From Profile")
            
            
            
        }
    }
    
    @IBAction func unwindFromEventDetail(sender: UIStoryboardSegue) {
        
        if sender.source is LoginViewController {
            
            print("BAck From Event")
            
            
            
        }
    }
    
    
    
    
}
