//
//  HomeVC.swift
//  Final Project Storyboard Design
//
//  Created by Trungski Ngo-Goldberg on 7/18/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit


//MARK: customized table cell FinalResultCell
class FinalResultCell: UITableViewCell {
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    
    @IBOutlet weak var stadium: UIButton!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var matchTime: UILabel!
}


//MARK: HomeVC
class HomeVC: ObservingVC, UITableViewDelegate, UITableViewDataSource {
    static let FinalResultCellID = "Final Result Cell"
    
    @IBOutlet weak var finalResultTable: UITableView!
    var homeData = AppDel.myCentralDataModel.listOfBasicResults
    
    private var matchLocation = ""
    //MARK: supportive property for navigating the match location
    var location: String {
        get {
            return matchLocation
        }
    }
    
    //MARK: current row for updating the MatchAnalyisDataModel
    private var curRow: Int = 0
    var row: Int {
        get {
            return curRow
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Total number of matches in the knock-out stage \(homeData.count) ")
        return homeData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier( HomeVC.FinalResultCellID, forIndexPath: indexPath)
            as? FinalResultCell
            else {
                Util.log("Incorrect cell-- cannot dequeue resuable cell ")
                return UITableViewCell()
        }
        let row = indexPath.row
        
        cell.homeTeam.text = homeData[row].homeName
        cell.awayTeam.text = homeData[row].awayName
        cell.homeScore.text = "\(homeData[row].homeScore)"
        cell.awayScore.text = "\(homeData[row].awayScore)"
        
        cell.matchDate.text = homeData[row].matchDate
        cell.matchTime.text = homeData[row].matchTime
        cell.stadium.setTitle(homeData[row].stadium, forState: .Normal)
        cell.city.text = homeData[row].city
        
        //        matchLocation   = homeData[row].matchLoc
        //        cell.matchLocation.text = matchLocation
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        curRow = row
        Util.log("Enter the Final Break Down VC from HomeVC's cell at \(curRow)")
        programaticSegue(row)
    }
    
    //MARK: segue from HomeVC's stadium UIButton to StadiumMapVC and apply the geocoding to translate its human-readable text address to CC coords of latitute/longtitude
    
    
    //MARK: segue to FinalBreakdownVC
    private func programaticSegue(row: Int){
        guard let finalBreakDownVC = UIStoryboard.make(FinalResultBreakDownVC.FinalResultBreakDownVCID) as? FinalResultBreakDownVC
            else {
                Util.log("Segue doesn't recognize the identifier of FinalResultBreakDownVC")
                return
        }
        
        //else, access the MatchAnalyisData for the current row and parse data into labels
        var breakdownModel = AppDel.myCentralDataModel.listOfMatches
        let curAnalysis =  breakdownModel[row]
        /************************/
        finalBreakDownVC.matchday =  "\(curAnalysis.matchday)"
        finalBreakDownVC.homeName = curAnalysis.homeName
        finalBreakDownVC.awayName  = curAnalysis.awayName
        finalBreakDownVC.homeScore = "\(curAnalysis.homeScore)"
        finalBreakDownVC.awayScore = "\(curAnalysis.awayScore)"
        finalBreakDownVC.homeGoalsHT  = "\(curAnalysis.homeScoreHalfTime)"
        finalBreakDownVC.awayGoalsHT = "\(curAnalysis.awayScoreHalfTime)"
        
        //        analyze the optional property accesed in the breakdownData
        if let homeET = curAnalysis.homeScoreExtraTime,
            let awayET = curAnalysis.awayScoreExtraTime
        {
            if let homePEN = curAnalysis.homePenalty,
                let awayPEN = curAnalysis.awayPenalty
            {
                finalBreakDownVC.homeGoalsET = "\(homeET)"
                finalBreakDownVC.awayGoalsET = "\(awayET)"
                finalBreakDownVC.homePEN = "\(homePEN)"
                finalBreakDownVC.awayPEN = "\(awayPEN)"
                
                self.navigationController?.pushViewController(finalBreakDownVC, animated: true)
            }
            else {
                finalBreakDownVC.homeGoalsET = "\(homeET)"
                finalBreakDownVC.awayGoalsET = "\(awayET)"
                finalBreakDownVC.hiddenPEN = true
                
                self.navigationController?.pushViewController(finalBreakDownVC, animated: true)
                let alert = UIAlertController(title: "Extra time, but no penalty shootout", message: "This match result between \(curAnalysis.homeName) and \(curAnalysis.homeName) was determined within the additional 30-minute extra time out of 120 minutes", preferredStyle: .Alert)
                
                presentViewController(alert, animated: true, completion: nil)
                //                    {
                //                    () -> Void in
                //                })
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Default,
                    handler:          nil))
            }
        }
        else {
            finalBreakDownVC.hiddenET   = true
            finalBreakDownVC.hiddenPEN = true
            self.navigationController?.pushViewController(finalBreakDownVC, animated: true)
            let alert = UIAlertController(title: "No penalty shootout and extra time", message: "This match result between \(curAnalysis.homeName) and \(curAnalysis.homeName) was determined within the regular 90-minute time", preferredStyle: .Alert)
            
            presentViewController(alert, animated: true, completion: nil )
            //                {
            //                () -> Void in
            //                //--> If working, then modify the handler to set the buttons hidden
            //                //                self.navigationController?.popoverPresentationController
            //            })
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default,
                handler: { (alert) -> Void in
                    
            }))
        }
    }
    
    //MARK: segue from HomeVC's cell to FinalBreakdownVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsTabBarController = segue.destinationViewController as! UITabBarController
        
        //modify the animation of segue by changing the speed's duration
        //                transitionFromViewController(self, toViewController: settingsTabBarController, duration: SegueSettings.animationSpeed, options: .TransitionCrossDissolve, animations: nil, completion: nil)
        //this code is not working in this case of parent view is UITabViewController
        
        guard let settingsViewControllers = settingsTabBarController.viewControllers else {
            preconditionFailure("Wrong destination of the segue")
        }
        
        let finalResultBreakdownVC = settingsViewControllers[0] as! FinalResultBreakDownVC
        //finalResultBreakdownVC.didMoveToParentViewController(settingsTabBarController)
        
        let stadiumMapVC = settingsViewControllers[1] as! StadiumMapVC
        //  stadiumMapVC.didMoveToParentViewController(settingsTabBarController)
    }
    
    //MARK: MVC life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("Loading \(unsafeAddressOf(self))")
        self.navigationController?.navigationBar.backgroundColor = NavigationBarBackground.BackgroundColor
    }
}

class SettingsTabBarController: UITabBarController {
    static let SettingsTabBCID = "Settings Tab Bar Controller"
}
