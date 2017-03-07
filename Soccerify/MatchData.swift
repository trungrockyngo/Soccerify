//
//  TeamData.swift
//  Soccerify
//
//  Created by Trungski Ngo-Goldberg on 7/30/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import Foundation

struct Euro2016WGeneralInfo {
    let numMatch: Int
}

class MatchAnalysisData: CustomStringConvertible  {
    //the Swift object selectively chosen amongst JSON properties
    var matchday: Int
    var matchDate : String
    var matchTime: String
    var homeName: String
    var awayName: String
    var homeScore: Int
    var awayScore: Int
    var homeScoreHalfTime: Int
    var awayScoreHalfTime: Int
    var homeScoreExtraTime: Int?
    var awayScoreExtraTime: Int?
    var homePenalty : Int?
    var awayPenalty: Int?
    
    init(matchday: Int, matchDate : String, matchTime: String,
         homeName: String, awayName: String, homeScore: Int, awayScore: Int, homeScoreHalfTime : Int, awayScoreHalfTime: Int, homeScoreExtraTime: Int?, awayScoreExtraTime: Int? , homePenalty: Int?, awayPenalty: Int? ) {
        self.matchday = matchday
        self.matchDate = matchDate
        self.matchTime = matchTime
        self.homeName = homeName
        self.awayName = awayName
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.homeScoreHalfTime = homeScoreHalfTime
        self.awayScoreHalfTime = awayScoreHalfTime
        self.homeScoreExtraTime = homeScoreExtraTime
        self.awayScoreExtraTime = awayScoreExtraTime
        self.homePenalty = homePenalty
        self.awayPenalty = awayPenalty
        
        // The nil penalty may wind up in the interface as a message, e.g.
        // "No Penalty Kick phase in this match."
    }
    
    var description: String {
        get {
            return "\(homeName) vs \(awayName) is \(homeScore)-\(awayScore). After the half-time \(homeScoreHalfTime)-\(awayScoreHalfTime). After the extra time, \(homeScoreExtraTime)-\(awayScoreExtraTime), and in the penalty shoot-out, \(homePenalty)-\(awayPenalty)"
        }
    }
}

class BasicMatchResult: CustomStringConvertible {
    var matchTime : String
    var matchDate : String
    var city : String
    var stadium : String
    var homeName: String
    var awayName: String
    var homeScore: Int
    var awayScore: Int
    
    init(matchDate: String, matchTime: String, stadium: String, city: String, homeName: String, awayName: String, homeScore: Int, awayScore: Int){
        self.matchDate = matchDate
        self.matchTime = matchTime
        self.stadium  = stadium
        self.city    = city
        self.homeName  = homeName
        self.awayName  = awayName
        self.homeScore = homeScore
        self.awayScore  = awayScore
    }
    var description: String{
        get {
            return "\(homeName) and \(awayName) is \(homeScore) -\(awayScore) at \(stadium), \(city) at \(matchTime) on \(matchDate)"
        }
    }
    //MODIFY the format (font, color, style) to present them in RoundSearchVC
}

class MatchListable: CustomStringConvertible {
    var homeName: String
    var awayName: String
    
    init( homeName: String, awayName: String ){
        self.homeName = homeName
        self.awayName = awayName
    }
    
    var description: String  {
        get {
            return "\(homeName) - \(awayName)"
        }
    }
    //MODIFY the format (font, color, style) to present them in HomeVC
}