//
//  GlobalVariable.swift
//  Rea2017
//
//  Created by MENES SIMEU on 07/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
class GlobalVariables {
    
    // These are the properties you can store in your singleton
    private var myName: String = "bob"
    var userProfil: User? = nil
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
