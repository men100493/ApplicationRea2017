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
    
    //Varibles globale de l'utilisateur
    var userProfil: User? = nil
    
    
    //-------------------------------------
    // MARK: - Music Story API KEYS
    //-------------------------------------
    
    private let MusicStoryAPIKEY = "8eceee961c54f58f5ee5c4bf152cb92031c9bf49"
    
    private let MusicStorySignAPI = "6ba1c42597d28961a6c6e9216d5ef00bfb37c9cd"
    
    let urlMusicStoryAPIBEG =  "http://api.music-story.com/"
    
    let urlMusicStoryAPIEND:String = "&oauth_token=" + GlobalVariables.sharedManager.MusicStoryAPIKEY + "&oauth_signature=" + GlobalVariables.sharedManager.MusicStorySignAPI
    
    
//&oauth_token=8eceee961c54f58f5ee5c4bf152cb92031c9bf49&oauth_signature=4ea540d8bdfd071a2594808bf5e6255d59231ddc
    
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
