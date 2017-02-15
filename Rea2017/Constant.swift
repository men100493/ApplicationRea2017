//
//  Constant.swift
//  Rea2017
//
//  Created by MENES SIMEU on 13/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
struct Constants {
    
    static let appName: String = "Sounds Meetings"
    
    
    struct Users {
        
        static var user: User?
        
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
    
}
