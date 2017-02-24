//
//  Constant.swift
//  Rea2017
//
//  Created by MENES SIMEU on 13/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let appName: String = "Sounds Meetings"
    
    
    struct Users {
        
        static var user: User?
        
        static var tabUser = [User]()
        
        static var tabEventFav = [FBEvent]()
        
    }
    
    
    struct Events{
        
        static var tabEvent = [FBEvent]()
        
        func addEvent (event: FBEvent){
            Events.tabEvent.append(event)
        }
    }
    
    struct Aperos{
        
        static var tabEApero = [Apero]()

    }
    struct Color {
        static let  rougeDeClaudius:UIColor = UIColor(colorLiteralRed: 246.0, green: 36.0, blue: 89.0, alpha: 1.0)
        
        static let  jauneDeClaudius:UIColor = UIColor(colorLiteralRed: 245.0, green: 215.0, blue: 110.0, alpha: 1.0)

    }
    
}
