//
//  DataManager.swift
//  Soccerify
//
//  Created by Trungski Ngo-Goldberg on 7/29/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import Foundation
import UIKit


public class DataManager {
    
    //Design setback: didn't set the operational thread queue before
    private (set) var opQueue : NSOperationQueue
    
    private var matchDataArray: [ MatchAnalysisData ]
    private var roundMenu  : [ RoundMenu]
    private var basicMatchResultArray : [BasicMatchResult]
    private var matchDay: Int
    
    var listOfMatches : [MatchAnalysisData] {
        get {
            return matchDataArray
        }
    }
    
    var listOfRounds: [RoundMenu]{
        get {
            return roundMenu
        }
    }
    
    var listOfBasicResults: [BasicMatchResult] {
        get {
            return basicMatchResultArray
        }
    }
    
    var curMatchday : Int {
        get {
            return matchDay
        }
    }
    
    init(opQueue: NSOperationQueue){
        matchDataArray = [MatchAnalysisData] ()
        roundMenu = [RoundMenu] ()
        basicMatchResultArray = [BasicMatchResult]()
        matchDay = 0
        self.opQueue = opQueue
        self.parseJSONFromBundle()
    }
    
    func parseJSONFromBundle (){
        //get a URL reference of JSON file locally. But I can also get the URL from the web server if needed
        //        var error: NSError?
        guard let path = NSBundle.mainBundle().URLForResource("TeamData", withExtension: "json") else {
            Util.log("No path existed at")
            return
        }
        //return the raw content from the file
        guard let dataContent = NSData(contentsOfURL: path) else {
            Util.log("There are no content in this file")
            return
        }
        //parse the JSON data by the de-serialization technique
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(dataContent, options: .AllowFragments)
            
            if let dictionaryJSON = object as? [String: AnyObject] {
                //read JSON data object from the "dictionary"
                readJSONObject(dictionaryJSON)
            }
        }
        catch _ as NSError{
            //handling error by the callback yet to be implemented by the method jsonDidArrive
            Util.log("JSON data wasn't parsed successfully")
        }
        
    }
    
    func readJSONObject( object: [String: AnyObject]) {
        guard let numOfMatch = object["count"] as? Int,
            //fixtures as an array of dictionary
            let fixtures = object["fixtures"] as? [[String: AnyObject]]
            else { return }
        //        print("The total of number of matches in the knock-out stage is \(numOfMatch)")
        
        var matchData : MatchAnalysisData
        
        //Rounds of 16
        var roundsOf16Label = ""
        var roundsOf16 : RoundMenu
        var roundsOf16Matches = [MatchListable]()
        //Quarter Final
        var quarterFinalLabel = ""
        var quarterFinal: RoundMenu
        var quarterFinalMatches = [MatchListable]()
        //Semi Final
        var semiFinalLabel = ""
        var semiFinal: RoundMenu
        var semiFinalMatches = [MatchListable]()
        //Final
        var finalLabel = ""
        var final : RoundMenu
        var finalMatch = [MatchListable]()
        
        var matchDate = ""
        var matchTime  = ""
        var stadium = ""
        var city = ""
        for fixture in fixtures
        {
            guard let matchday = fixture["matchday"] as? Int,
                let matchFullDate = fixture["date"] as? String,
                let matchLoc = fixture["stadium"] as? String,
                let homeName = fixture["homeTeamName"] as? String,
                let awayName = fixture["awayTeamName"] as? String,
                let result = fixture["result"] as? [String: AnyObject]
                else { return }
            /*** extract the string matchLoc into the city and stadium name ***/
            let locArr = matchLoc.componentsSeparatedByString(",")
            stadium = locArr[0]
            city = locArr[1]
            
            /*** extract the string matchTime into the match date and time  ***/
            matchDate = matchDateRemoveTrivals(matchFullDate)
            matchTime = "\(matchTimeRemoveTrivals(matchFullDate)) ET"
            
            print("The match between \(homeName) vs \(awayName)")
            
            //get into the breakdown result of the current match
            guard let homeScore = result["goalsHomeTeam"] as? Int,
                let awayScore = result["goalsAwayTeam"] as? Int,
                let halfTime = result["halfTime"] as? [String: AnyObject]
                else { return }
            //            print("its match result is \(homeScore) - \(awayScore)")
            
            basicMatchResultArray.append(BasicMatchResult(matchDate: matchDate, matchTime: matchTime, stadium: stadium, city: city, homeName: homeName, awayName: awayName, homeScore: homeScore, awayScore: awayScore))
            
            guard let homeScoreHalfTime =  halfTime["goalsHomeTeam"] as? Int,
                let awayScoreHalftime =  halfTime["goalsAwayTeam"] as? Int else {return}
            //            print( "After the half time, it's \(homeScoreHalfTime) - \(awayScoreHalftime)")
            
            //MARK: since the extraTime is not required for every match's fixture, so accept the case when it's nil (but then has to CONTINUE on the loop)
            guard  let extraTime = result["extraTime"] as? [String: AnyObject]? else {
                print("The match has no extra time!")
                continue
            }
            
            //MARK: since the penaltyShootout is optional for every match's fixture, so accept the case when it's nil (but then has to CONTINNUE from the loop)
            guard let penaltyShootout = result["penaltyShootout"] as? [String: AnyObject]? else {
                print("The match has no penalty shoot-out")
                continue
            }
            
            // Daniel: This already matches the type the constructor wants.
            // Since the constructor is accepting a maybe-nil value, it has
            // the unwrapping /  nil-handling logic, so nothing to do here
            let homeScoreExtraTime = extraTime?["goalsHomeTeam"] as? Int
            let awayScoreExtraTime =  extraTime?["goalsAwayTeam"] as? Int
            // THen not 3 but one constructor call
            
            let homePenalty = penaltyShootout?["goalsHomeTeam"] as? Int
            let awayPenalty = penaltyShootout?["goalsAwayTeam"] as? Int
            
            matchData = MatchAnalysisData(matchday: matchday, matchDate: matchDate, matchTime: matchTime, homeName: homeName, awayName: awayName, homeScore: homeScore, awayScore: awayScore, homeScoreHalfTime: homeScoreHalfTime, awayScoreHalfTime: awayScoreHalftime, homeScoreExtraTime: homeScoreExtraTime, awayScoreExtraTime: awayScoreExtraTime, homePenalty: homePenalty, awayPenalty: awayPenalty)
            print(matchData.description)
            matchDataArray.append(matchData)
            
            //partition each match of fixtures based on matchDay into RoundMenu
            //            print(matchday)
            switch matchday {
            case 4:
                roundsOf16Label = "Rounds of 16"
                roundsOf16Matches.append(MatchListable(homeName: homeName, awayName: awayName))
            case 5:
                quarterFinalLabel = "Quarter Final"
                quarterFinalMatches.append(MatchListable(homeName: homeName, awayName: awayName))
            case 6:
                semiFinalLabel = "Semi Final"
                semiFinalMatches.append(MatchListable(homeName: homeName, awayName: awayName))
            case 7:
                finalLabel = "Final"
                finalMatch.append(MatchListable(homeName: homeName, awayName: awayName))
            default:
                print("There's no match on the matchday: \(matchday)")
            }
        } //end for-loop
        
        //Fix the incremental and repeated instances of RoundMenu --> construct new RoundMenu only when the partion is done
        roundsOf16 = RoundMenu(label: roundsOf16Label, elements: roundsOf16Matches)
        quarterFinal = RoundMenu(label: quarterFinalLabel, elements: quarterFinalMatches)
        semiFinal = RoundMenu(label: semiFinalLabel, elements: semiFinalMatches)
        final = RoundMenu(label: finalLabel, elements: finalMatch)
        roundMenu = [roundsOf16, quarterFinal, semiFinal, final]
    }
    
    //helper method to manipulate the matchDate with string regex
    private func matchDateRemoveTrivals (matchDate: String ) -> String {
        //simpler version of pattern matching
        let dateStart = matchDate.startIndex
        let dateEnd = dateStart.advancedBy(9)
        let range = dateStart...dateEnd
        let modMatchDate = matchDate.substringWithRange(range)
        return modMatchDate
    }
    
    private  func matchTimeRemoveTrivals (matchDate: String) -> String {
        let timeStart = matchDate.startIndex.advancedBy(11)
        let timeEnd = matchDate.endIndex.advancedBy(-5)
        let range = timeStart...timeEnd
        let modTimeEnd = matchDate.substringWithRange(range)
        return modTimeEnd
    }
}