//
//  Apero.swift
//  Rea2017
//
//  Created by MENES SIMEU on 14/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation

class Apero: NSObject {
    var id: String? = nil
    var name: String? = nil
    //var date: String? = nil
    var nbInvite: String? = nil
    //var adresse: String? = nil
    var descrip: String? = nil
    
    init(id: String, name:String,nbInvite:String,descrip: String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        //self.adresse = adresse
        self.descrip = descrip
    }

}
