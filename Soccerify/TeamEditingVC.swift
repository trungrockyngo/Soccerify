//
//  SoccerifyPersistence.swift
//  Soccerify
//
//  Created by Trungski Ngo-Goldberg on 7/29/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import Foundation


//The preliminary idea: create the view controller that allows users to modify the wiki info of the club
class TeamDataModel : NSObject, NSCoding {
    //property abstraction, also used as keys for the encoding
    var uiid: String = NSUUID().UUIDString //read-only and static for every item
    var name: String?
    var teamDescription: String?
    var stadiumDescription: String?
    
    init(name: String?, teamDescription: String?, stadiumDescription: String?){
        self.name = name
        self.teamDescription = teamDescription
        self.stadiumDescription = stadiumDescription
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //awake the custom persisted data object from the file system 
        if let uiidVal = aDecoder.decodeObjectForKey("uiid"),
            let nameVal = aDecoder.decodeObjectForKey("name") as! String?,
            let teamDescriptionVal = aDecoder.decodeObjectForKey("teamDescription") as! String?,
            let stadiumDescriptionVal = aDecoder.decodeObjectForKey("stadiumDescription") as! String?
        {
            uiid = uiidVal as! String
            name = nameVal
            teamDescription = teamDescriptionVal
            stadiumDescription = stadiumDescriptionVal
        }
    }
    
    //encoding the object to save to the disk
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(uiid, forKey: "uiid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(teamDescription, forKey: "teamDescription")
        aCoder.encodeObject(stadiumDescription, forKey: "stadiumDescription")
    }
}


//TeamEditingVC has some functionality similarities to table editor view controller  
//class TeamEditingVC: ObservingVC, UITableViewDataSource, UITableViewDelegate {
//    
//}