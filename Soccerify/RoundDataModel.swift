//
//  RoundDataModel.swift
//  Soccerify
//
//  Created by Trungski Ngo-Goldberg on 7/28/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import Foundation

class RoundMenu {
    let label: String
    //stored property for efficiency
    private var rawData: [MatchListable]
    private var filteredData = [ MatchListable ]()
    private var lastFilter: String?
    
    weak var constraintsDelegate: SearchConstraintsDelegate?
    
    init(label: String, elements: [MatchListable]){
        self.label = label
        rawData = elements
    }
    
    private var filteredResults : [MatchListable] {
        if let constraints = self.constraintsDelegate where constraints.currentFilter != "" {
            //if the current filter is new, then update the current filter
            if constraints.currentFilter != lastFilter {
                lastFilter = constraints.currentFilter
                filteredData = rawData.filter { (element) in
                    let elemDesc = element.description.lowercaseString
                    let matchString = constraints.currentFilter.lowercaseString
                    return elemDesc.rangeOfString(matchString) != nil
                }
            }
            return filteredData
        }
        return rawData //otherwise return current element list
    }
    
    var count: Int {
        return filteredResults.count
    }
    
    subscript(index: Int) -> MatchListable? {
        get {
            if index >= 0 && index <= filteredResults.count {
                return filteredResults[index]
            }
            return nil
        }
    }
}

//MARK: RoundMenuModel adopt SearchConstraintDataSource
class RoundMenuModel: SearchContraintsDataSource {
    lazy var filterChanged: NSNotification = NSNotification(name: Notifications.AppModel, object: self, userInfo: [Notifications.MessageKey : Notifications.FilterDidChangeMessage])
    
    var dataValues = AppDel.myCentralDataModel.listOfRounds
    
    init() {
        for data in dataValues {
            data.constraintsDelegate = self
        }
        
    }
    
    //MARK: SearchConstraintsDelegate
    var currentFilter: String = ""{
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(filterChanged)
        }
    }
    
    //MARK: SearchConstraintsDataSource
    func numSections() -> Int {
        return dataValues.count
    }
    
    func numOfElementsInSection(section: Int) -> Int? {
        if (section >= 0 && section <= dataValues.count){
            return dataValues[section].count
        }
        else {
            return nil
        }
    }
    
    func sectionNameFromIndex(index: Int) -> String? {
        if (index >= 0 && index <= dataValues.count) {
            return dataValues[index].label
        }
        else {
            return nil
        }
    }
    
    func valueFromSection(section: Int, atIndex index: Int) -> MatchListable? {
        if (section >= 0 && section <= dataValues.count && index >= 0 && index <= dataValues.count)
        {
            return dataValues[section][index]
        }
        else {
            return nil
        }
    }
    
    
}