//
//  File.swift
//  Final Project Storyboard Design
//
//  Created by Trungski Ngo-Goldberg on 7/19/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import AVFoundation


//MARK: prammatically layout for the web view
extension UIViewController  {
    func layoutOnTopOfWebView( dv: UIView, forProgramaticView pv: UIView){
        pv.translatesAutoresizingMaskIntoConstraints  = false
        view.addSubview(pv)
        //add constraints based on rectangular attributes
        for attr: NSLayoutAttribute in [.Bottom, .Left, .Top, .Right] {
            view.addConstraint(NSLayoutConstraint(item: dv, attribute: attr, relatedBy: .Equal, toItem: pv, attribute: attr, multiplier: 1.0, constant: 0.0))
        }
    }
}

let videoExtensions = [ "mp3", "mp4", "m4v", "mov", "aac", "m4a" ]

//protocol FinalBreakdownModelDelegate {
//    func modelChanged(finalBreakdownRVC: FinalResultBreakDownVC)
//}

class FinalResultBreakDownVC: ObservingVC  {
    
    static let FinalResultBreakDownVCID = "Final Result Break Down VC"
    static let MatchAnalysisCellID = "Match Analysis Cell"
    
    //    @IBOutlet weak var competionView: UIImageView!
    //    @IBOutlet weak var matchAnalyis: UITableView!
    
    var curMatchday: Int = 0
    
    var homeName: String?
    var awayName: String?
    var matchday: String?
    var homeScore: String?
    var awayScore: String?
    var homeGoalsHT: String?
    var awayGoalsHT: String?
    var homeGoalsET : String?
    var  awayGoalsET: String?
    var homePEN: String?
    var awayPEN: String?
    
    @IBOutlet weak var mDay: UILabel! {
        didSet {
            mDay.text = matchday
        }
    }
    @IBOutlet weak var homeTeamName: UILabel!
        {
        didSet {
            homeTeamName.text = homeName
        }
    }
    
    @IBOutlet weak var awayTeamName: UILabel!
        {
        didSet {
            awayTeamName.text = awayName
        }
    }
    @IBOutlet weak var HS: UILabel! {
        didSet {
            HS.text = homeScore
        }
    }
    
    @IBOutlet weak var AS: UILabel!  {
        didSet {
            AS.text = awayScore
        }
    }
    @IBOutlet weak var HHT: UILabel! {
        didSet {
            HHT.text = homeGoalsHT
        }
    }
    @IBOutlet weak var AHT: UILabel! {
        didSet {
            AHT.text = awayGoalsHT
        }
    }
    @IBOutlet weak var HET: UILabel! {
        didSet {
            HET.text = homeGoalsET
        }
    }
    @IBOutlet weak var AET: UILabel! {
        didSet {
            AET.text = awayGoalsET
        }
    }
    
    @IBOutlet weak var HP: UILabel!  {
        didSet {
            HP.text = homePEN
        }
    }
    
    @IBOutlet weak var AP: UILabel! {
        didSet {
            AP.text = awayPEN
        }
    }
    
    var hiddenET: Bool = false
    var hiddenPEN: Bool = false
    @IBOutlet weak var ExtraTime: UILabel! {
        didSet {
            ExtraTime.hidden = hiddenET
        }
    }

    @IBOutlet weak var PenaltyShootout: UILabel! {
        didSet {
            PenaltyShootout.hidden = hiddenPEN
        }
    }
    
    @IBOutlet weak var webView: UIView!
    

    //MARK: segueing from FinalBreakDownVC's WVWeblinks to video highlights
    private func performprogramaticSegue(){
        //         guard let segue = UIStoryboard.make()
    }
    
    //MARK: MVC life-cycle
    private func buildLayout(){
        let homeButton = UIBarButtonItem(image: UIImage(named: "Round Menu"), style: .Plain, target: self, action: #selector (HomeContainerVC.settingsTapped(_:)))
        
        guard let backButton = self.navigationItem.backBarButtonItem else {
            return
        }
        self.navigationItem.title = "Match Breakdown"
        
        let leftButtonArray = NSArray(array: [homeButton, backButton]) as? [UIBarButtonItem]
        self.navigationItem.setLeftBarButtonItems(leftButtonArray, animated: true)
    }
    
    /** Persist data for the segmented control of each team  **/
    let myDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var homePerformance: UISegmentedControl!
    @IBOutlet weak var awayPerformance: UISegmentedControl!
    
    @IBOutlet weak var numVotes: UILabel!
    @IBOutlet weak var votesHome1: UILabel!
    @IBOutlet weak var votesHome2: UILabel!
    @IBOutlet weak var votesHome3: UILabel!
    
    @IBOutlet weak var votesAway1: UILabel!
    
    @IBOutlet weak var votesAway2: UILabel!
    
    @IBOutlet weak var votesAway3: UILabel!
    
    @IBAction func saveAction(sender: AnyObject) {
        //        alert("Please vote for your favorite team's performance!", message: "")
        myDefaults.setInteger(homePerformance.selectedSegmentIndex, forKey: PerformanceRatingKey.HomePerformance)
        myDefaults.setInteger(awayPerformance.selectedSegmentIndex, forKey: PerformanceRatingKey.AwayPerformance)
        
        myDefaults.setInteger(homePerformance.selectedSegmentIndex, forKey: PerformanceRatingKey.HomePerformance)
        myDefaults.setInteger(awayPerformance.selectedSegmentIndex, forKey: PerformanceRatingKey.AwayPerformance)
        getSavedRating()
        alert("Thanks for voting", message: "")
    }
    //TASK: Need to persist the following property
    var vH1 = 0
    var vH2 = 0
    var vH3 = 0
    var vA1 = 0
    var vA2 = 0
    var vA3 = 0
    var totalVotes = 0
    func getSavedRating() {
        if (homePerformance.touchInside && awayPerformance.touchInside) {
            alert("Please vote only one out of two teams", message: "")
            homePerformance.highlighted = false
            awayPerformance.highlighted = false
        }
        else {
            switch awayPerformance.selectedSegmentIndex {
            case 0:
                vA1 += 1
                votesAway1.text = "\(vA1)"
            case 1:
                vA2 += 1
                votesAway2.text = "\(vA2)"
            case 2:
                vA3 += 1
                votesAway3.text = "\(vA3)"
            default:
                break
            }
            
            switch homePerformance.selectedSegmentIndex {
            case 0:
                vH1 += 1
                votesHome1.text = "\(vH1)"
            case 1:
                vH2 += 1
                votesHome2.text = "\(vH2)"
            case 2:
                vH3 += 1
                votesHome3.text = "\(vH3)"
            default:
                break
            }
        }
        totalVotes = vH1 + vH2 + vH3 + vA1 + vA2 + vA3
        numVotes.text = "\(totalVotes)"
    }
    
    //MARK: play webview URL's video sites
    //parse the URLs loaded in each HTML page of the set; display each on them
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        
        //Design setback: didn't update the model ocbserver
        //        modelObserver = NSNotificationCenter.defaultCenter().addObserverForName("Match Analysis Data Model updated", object: AppDel.myCentralDataModel, queue: AppDel.myCentralDataModel.opQueue) {
        //            [weak self] (notification : NSNotification) in self?.updateUIFromModelQueue(self!.homeVC.row) --> row always set to 0 even if updateUIFromModelQueue is fired --> this track using op-queue is leading me to a dead end!!
        //        }
        getSavedRating()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
}