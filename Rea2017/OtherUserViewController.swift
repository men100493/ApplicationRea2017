//
//  OtherUserViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 22/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class OtherUserViewController: UIViewController {
    var otherUser :User?

    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if otherUser != nil  {
            userNameLabel.text = otherUser?.nom
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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