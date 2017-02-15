//
//  SearchViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 06/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource, UISearchResultsUpdating{
        @IBOutlet weak var loginBtnOutlet: UIButton!

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // ADD THE UISearchController
    var searchController:UISearchController!
    
    
    var user :User?
    
    //create two arrays
    var friendsArray = [String]()       //array of all frineds
    var filteredFriends = [String]()    //array of filtered friends
    
    
    var arraySearch = [NSObject]()
    var arraySearchFiltered = [NSObject]()
    
    
    var arrayEventSearch = [FBEvent]()
    var arrayEventSearchFiltered = [FBEvent]()
    
    var arrayAperotSearch = [Apero]()
    var arrayAperoSearchFiltered = [Apero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.getBDDAperos()
        //searchTableView.delegate = self
        //searchTableView.dataSource = self
        // Do any additional setup after loading the view.
         initHomeViewController()
        
        for event in Constants.Events.tabEvent! {
            self.friendsArray.append(event.name!)
        }
//        for apero in Constants.Aperos.tabEApero!{
//            self.friendsArray.append(apero.id!)
//        }
        
        
        //let appDelegate = UIAdelegate as! AppDelegate
        user = Constants.Users.user
        
        
        //ADD THIS SEARCH CONTROLLER CODE!!!
        
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

    }
    
    
    //-------------------------------------
    // MARK: - UI Search
    //-------------------------------------
    
    // Uupdate searching results
 
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText: searchText!)
        searchTableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Title")
    {
        self.filteredFriends = self.friendsArray.filter({(friend : String) -> Bool in
            
            var categoryMatch = (scope == "Title")
            //var stringMatch = friend.rangeOfString(searchText)
            var stringMatch = friend.range(of: searchText)
            return categoryMatch && (stringMatch != nil)
            
        })
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchString searchString: String!) -> Bool { //CHANGE FROM UISearchDisplayController TO UISearchController !!!
        
        self.filterContentForSearchText(searchText: searchString, scope: "Title")
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchScope searchOption: Int) -> Bool { //CHANGE FROM UISearchDisplayController TO UISearchController !!!
        
        self.filterContentForSearchText(searchText: self.searchController!.searchBar.text!, scope: "Title") //CHANGE FROM searchDisplayController TO searchController !!!
        
        return true
        
    }
    
    

    
    //-------------------------------------
    // MARK: - TableView
    //-------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchController.isActive){ //CHANGE tableView == self.searchDisplayController?.searchResultsTableView TO searchController.active
            
            return self.filteredFriends.count
            
        }else{
            
            return self.friendsArray.count
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell")
        
        var friend: String
        
        if (searchController.isActive){ //CHANGE FROM tableView == self.searchDisplayController?.searchResultsTableView TO searchController.active !!!
            
            friend = self.filteredFriends[indexPath.row]
            
        }else{
            
            friend = self.friendsArray[indexPath.row]
            
        }
        
        cell?.textLabel?.text = friend
        
        return cell!
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        var friend: String
        
        if (searchController.isActive){ //CHANGE FROM tableView == self.searchDisplayController?.searchResultsTableView TO searchController.active !!!
            
            friend = self.filteredFriends[indexPath.row]
            
        }else{
            
            friend = self.friendsArray[indexPath.row]
            
        }
        
        print(friend)
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
        
        if self.user != nil {
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
            
        }
        
        if Helper.isConnectToFacebook() {
            Helper.getUserFBData()
            
            loginBtnOutlet.setTitle("Profil", for: .normal)
            return
        }
        loginBtnOutlet.setTitle("Login", for: .normal)
        
        print("Utilisateur non connecté")
        
        
        
    }
    
   
    @IBAction func LoginOrProfile(_ sender: Any) {
        //self.performSegue(let lg = LoginViewController()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if loginBtnOutlet.titleLabel?.text == "Login" {
            let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
        else{
            let vc : ProfilViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfilVC") as! ProfilViewController
            self.present(vc, animated: true, completion: nil)
            
            
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
    
}
