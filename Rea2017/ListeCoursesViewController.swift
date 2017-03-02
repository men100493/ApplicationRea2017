//
//  ListeCoursesViewController.swift
//  Rea2017
//
//  Created by MENES SIMEU on 02/03/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class ListeCoursesViewController: UIViewController {

    @IBOutlet weak var platBtnOutlet: UIButton!
    @IBOutlet weak var chipsBtnOutlet: UIButton!
    @IBOutlet weak var pizzaBtnOutlet: UIButton!
    @IBOutlet weak var alcFortBtnOutlet: UIButton!
    @IBOutlet weak var biereBtnOutlet: UIButton!
    @IBOutlet weak var vinBtnOutlet: UIButton!
    
    
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var biereLabel: UILabel!
    @IBOutlet weak var alcFortLabel: UILabel!
    @IBOutlet weak var pizzaLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var platLabel: UILabel!
    
    var vinVal:Int?
    var biereVal:Int?
    var alcFortVal:Int?
    var pizzaVal:Int?
    var chipsVal:Int?
    var platVal:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if vinVal == nil {
            vinVal = 0
        }
        if biereVal == nil {
            biereVal = 0
        }
        if alcFortVal == nil {
            alcFortVal = 0
        }
        if pizzaVal == nil {
            pizzaVal = 0
        }
        if chipsVal == nil {
            chipsVal = 0
        }
        if platVal == nil {
            platVal = 0
        }
        setValue()
    }
    
    func setValue() {
        vinLabel.text = NSString(format:"%i", vinVal!) as String
        biereLabel.text = NSString(format:"%i", biereVal!) as String
        alcFortLabel.text = NSString(format:"%i", alcFortVal!) as String
        pizzaLabel.text = NSString(format:"%i", pizzaVal!) as String
        chipsLabel.text = NSString(format:"%i", chipsVal!) as String
        platLabel.text = NSString(format:"%i", platVal!) as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func vinAdd(_ sender: Any) {
        
        if vinVal! < 10 {
            vinVal = vinVal! + 1
        }else{
            vinVal = 0
        
        }
        setValue()
    }
    
    @IBAction func biereAdd(_ sender: Any) {
        if biereVal! < 10 {
            biereVal = biereVal! + 1
        }else{
            biereVal = 0
            
        }
        setValue()
    }

    @IBAction func alcoolFortAdd(_ sender: Any) {
        
        if alcFortVal! < 10 {
            alcFortVal = alcFortVal! + 1
        }else{
            alcFortVal = 0
            
        }
        setValue()
        
    }
   
    @IBAction func pizzaAdd(_ sender: Any) {
        if pizzaVal! <= 10 {
            pizzaVal = pizzaVal! + 1
        }else{
            pizzaVal = 0
            
        }
        setValue()
    }
    @IBAction func chipsAdd(_ sender: Any) {
        if chipsVal! < 10 {
            chipsVal = chipsVal! + 1
        }else{
            chipsVal = 0
            
        }
        setValue()
    }
   
    @IBAction func platsAdd(_ sender: Any) {
        if platVal! < 10 {
            platVal = platVal! + 1
        }else{
            platVal = 0
            
        }
        setValue()
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
