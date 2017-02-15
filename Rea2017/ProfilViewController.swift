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
    
    @IBOutlet weak var profilPicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Constants.Users.user?.getFBPicture()
        var userID = Constants.Users.user?.id
        var pictureFB = Constants.Users.user?.photoProfilUrl
        //profilPicture.image = pictureFB
        print(pictureFB)
        nomLabelOutlet.text = Constants.Users.user?.nom
        prenomLabelOutlet.text = Constants.Users.user?.pnom
        
        
        let url = NSURL(string: pictureFB!)
        let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
        profilPicture.image = UIImage(data: data! as Data)
        
        

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
        // this is an instance function
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
    
    @IBAction func unwindFromProfilConfig(sender: UIStoryboardSegue) {
        
        if sender.source is ConfigProfilViewController {
            
            print("Données Sauvegardé")
            
            
            
        }
    }

}
