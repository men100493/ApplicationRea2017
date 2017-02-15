//
//  ProfilViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 08/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {

    @IBOutlet weak var nomLabelOutlet: UILabel!
    
    @IBOutlet weak var prenomLabelOutlet: UILabel!
    
    @IBOutlet weak var surnomLabelOutlet: UILabel!
    
    @IBOutlet weak var musicLabelOutlet: UILabel!
    
    @IBOutlet weak var adressLabelOutlet: UILabel!
    
    @IBOutlet weak var emailLabelOutlet: UILabel!
    
    @IBOutlet weak var phoneLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        nomLabelOutlet.text = Constants.Users.user?.nom
        prenomLabelOutlet.text = Constants.Users.user?.pnom
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutofftheaoo(_ sender: Any) {
        print("LogOut")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Constants.Users.user?.logout()
        Constants.Users.user = nil
        self.performSegue(withIdentifier: "LogoutOfProfil", sender: nil)
        
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
