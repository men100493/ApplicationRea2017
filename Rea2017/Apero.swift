//
//  Apero.swift
//  Rea2017
//
//  Created by MENES SIMEU on 14/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import Foundation
import Firebase

class Apero: NSObject {
    var id: String
    var name: String
    //var date: String? = nil
    var nbInvite: String
    var adresse: String? = nil
    var descrip: String? = nil
    var eventFb: String? = nil
    var start: String? = nil
    var end: String? = nil
    //var cp : String? = nil
    var userHostid: String? = nil
    var tabInvite = [User]()
    var tabInviteId = [String]()
    var tabCourse = [String : Int]()
    
    init(id: String, name:String,nbInvite:String,descrip: String, adresse : String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        self.adresse = adresse
        self.descrip = descrip
    }
    
    init(id: String, name:String,nbInvite:String,descrip: String, eventFB: String, adresse: String, startTime:String,endTime: String) {
        self.id = id
        self.name = name
        self.nbInvite = nbInvite
        
        self.descrip = descrip
        self.eventFb = eventFB
        self.adresse = adresse
        self.start = startTime
        self.end = endTime
       
    }
    
    
    
    
    func observeApero(){
        //let dic = [String: AnyObject]()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        //AFINIR MENES
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        ref.child("Apero").child(self.id).observe(.value, with: { (snapshot) in
            
            print(snapshot)
            
            let dic = snapshot.value as?  NSDictionary
            print(dic)
            if dic != nil {
                
               // let values = ["id":self.id, "title": self.name, "description": self.descrip, "FBEventId": self.eventFb, "nbGuest": self.nbInvite!, "address":self.adresse, "commence a": self.start, "fini a": self.end!, "cp": self.cp!, "UserHostId":(userHost?.id!)! as String] as [String : Any]
                if let aperoname = dic?["name"] as? String{
                    self.name = aperoname
                }
                if let add = dic?["address"] as? String{
                    self.adresse = add
                }
                if let aperodescr = dic?["description"] as? String{
                    self.descrip = aperodescr
                }
                if let aperonb = dic?["nbGuest"] as? String {
                    self.nbInvite = aperonb
                }
                
                if let aperostart = dic?["commence a"] as? String {
                    self.start = aperostart
                }
                if let aperoend = dic?["fini a"] as? String {
                    self.end = aperoend
                }
                if let aperofb = dic?["FBEventId"] as? String {
                    self.eventFb = aperofb
                }
                if let id = dic?["HostId"] as? String {
                    self.userHostid = id
                    
                }
                if let course = dic?["Courses"] as? [String: Int] {
                    for ( key, value ) in course {
                        self.tabCourse[key] = value
                        
                    }
                    
                }
                
                if let aperoInvite = dic?["Invite"] as? [String: AnyObject]{
                    var tabUser = [String]()
                    for apero in aperoInvite{
                        tabUser.append(apero.key)
                        print(apero.key)
                        //self.tabAperoId.append(id.key as! String)
                    }
                    self.tabInviteId = tabUser
                    var tabUser2 = [User]()
                    for user in Constants.Users.tabUser {
                        for id in self.tabInviteId {
                            if user.id == id {
                                tabUser2.append(user)
                            }
                        }
                    }
                    self.tabInvite = tabUser2
                    
                }
            }
            
        })
        //print(dic)
        
    }

    func saveAperoToBDD() {
        
        
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        //Problème d'ajout d'utlisaeut a un evenement 
        
        var values:[String : Any]
        
       
            values = ["id":self.id]
        
        
        if (self.userHostid == nil ) {
            values["HostId"] = (Constants.Users.user?.id)!
            
        }
            if !self.name.isEmpty {
                values["title"] = self.name
                
            }
            if !self.nbInvite.isEmpty {
                values["nbGuest"] = self.nbInvite
                
            }
            
            if !self.description.isEmpty {
                values["description"] = self.descrip
                
            }
            
            if !(self.eventFb?.isEmpty)! {
                values["FBEventId"] = self.eventFb
                
            }
            
            
            if !(self.adresse?.isEmpty)! {
                values["address"] = self.adresse
                
            }
            
            if !(self.start?.isEmpty)! {
                values["commence a"] = self.start
                
            }
            
            if !(self.end?.isEmpty)! {
                values["fini a"] = self.end
                
            }
            
        
        
   
        
        
        
        let usersReference = ref.child("Apero").child(self.id)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
        for( key, value ) in tabCourse{
            self.addCourse(nom: key, value: value)
        }
    }
    
    func saveEventToApero(event: FBEvent) {
        if eventFb == nil {
        
        let eventId =  event.id
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        self.eventFb = eventId
        let values = ["FBEventId": eventId ]
        
        let usersReference = ref.child("Apero").child(self.id)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create add event ", err ?? "")
                return
            }
            print(values)
        }
        self.observeApero()
        //Ecrire sur la BBD de L'event l'id de l'apéros associer GOOD LUCK
        
        //event.saveAperoToEvent(apero: self)
        }
        
    }
    func nbInviteAdd(){
        if var nb = Int(self.nbInvite) {
            nb = nb - 1
            self.nbInvite = String(nb)
            self.saveAperoToBDD()
        }
    }
    
    func  nbIvitePop(){
        if var nb = Int(self.nbInvite) {
            nb = nb + 1
            self.nbInvite = String(nb)
            self.saveAperoToBDD()
        }
    
    }
    
    

    
    func addUser(user: User){
        //AJouter a la BDD

        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = ["UserID": user.id,"UserNom": user.nom]
        
        let usersReference = ref.child("Apero").child(self.id).child("Invite").child(user.id!)
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create new user for this event ", err ?? "")
                return
            }
            print(values)
            self.nbInviteAdd()
            self.observeApero()
        }
       
    }
    func addCourse(nom :String , value: Int){
        //AJouter a la BDD
        
        let ref = FIRDatabase.database().reference(fromURL: "https://rea2017-f0ba6.firebaseio.com/")
        
        
        let values = [nom : value]
        
        let usersReference = ref.child("Apero").child(self.id).child("Courses")
        
        
        usersReference.updateChildValues(values) { (err, data) in
            if err != nil {
                print("Failed to create new user for this event ", err ?? "")
                return
            }
            print(values)
            self.tabCourse[nom] = value

        }
        
    }
    
    func popUser(user:User){
        //supprimer un ellement  de la BDD + nbInvitPop
        
        
    }
    
    func deleteApero(){
        
    }


}
