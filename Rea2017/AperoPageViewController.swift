//
//  AperoPageViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 15/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class AperoPageViewController: UIViewController ,UITextFieldDelegate ,UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var UserPresent: UILabel!
    @IBOutlet weak var predictiveTableView: UITableView!
    @IBOutlet weak var userAdd: UITextField!

    
    @IBOutlet weak var EventAperoLabel: UILabel!
    @IBOutlet weak var AperoNameLabel: UILabel!
    
    var apero : Apero?
    var tabPreditive = Constants.Users.tabUser
    var autoCompletename = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictiveTableView.isHidden = true
        userAdd.delegate = self
        predictiveTableView.delegate = self
        print( tabPreditive.count)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.apero != nil {
            AperoNameLabel.text = apero?.name
            EventAperoLabel.text = apero?.eventFb
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "predictiveCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.tabPreditive[indexPath.row].nom! + " " + self.tabPreditive[indexPath.row].pnom!
        

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabPreditive.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = self.tabPreditive[indexPath.row].nom! + " " + self.tabPreditive[indexPath.row].pnom!
        userAdd.text = selected
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userAdd.resignFirstResponder()
        predictiveTableView.isHidden = true
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         predictiveTableView.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //var myRange: NSRange = NSMakeRange(0, 2)
        let oldText = textField.text!
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        //let substring = (textField.text! as String).replacingCharacters(in: range.toRange(), with: string)
        searchAutocompleteEntriesWithSubstring(substring: newText)
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autoCompletename.removeAll(keepingCapacity: false)
        
        for user in tabPreditive
        {
            var myString = user.nom as NSString!
            var substringRange :NSRange! = myString!.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autoCompletename.append(myString as! String)
            }
        }
        
        predictiveTableView.reloadData()
    }

    @IBAction func AddUserToEvent(_ sender: Any) {
        
        if (userAdd.text?.isEmpty)! {
            
            
            let alertController = UIAlertController(title: "Problème", message:
                "Le champ n'a pas été remplis", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)

        
        }else{
            //AZZZYYYY j'ai la flème
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

}
