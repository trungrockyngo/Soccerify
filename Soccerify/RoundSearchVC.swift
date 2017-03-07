//
//  RoundSearchVC
//  Final Project Storyboard Design
//
//  Created by Trungski Ngo-Goldberg on 7/26/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit

// MARK: abstract notifications for RoundSearchVC
struct Notifications {
    static let AppModel = "Round Menu Model"
    static let MessageKey = "Message Key"
    static let FilterDidChangeMessage = "Filter Changed"
}

//MARK: Abstracted delegate protocol, much similiar to UITableViewDelegate
protocol SearchConstraintsDelegate: class {
    var currentFilter: String { get set }
}

//MARK: Abstracted data source model, much similiar to UITableViewDataSource
protocol SearchContraintsDataSource : SearchConstraintsDelegate {
    func valueFromSection (section: Int, atIndex  index: Int) -> MatchListable?
    func sectionNameFromIndex( index: Int)  -> String?
    func numSections() -> Int
    func numOfElementsInSection(section: Int)  -> Int?
}


class RoundSearchVC: ObservingVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    static let RoundSearchCellID = "Round Search Cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    private var model: SearchContraintsDataSource!{
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        searchBar.text = model.currentFilter //in case we just switched models, update search to what was being used for that model
        searchTableView.reloadData()
        print("The current filter is \(model.currentFilter)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Design error: based on the fact we choose the op queue to receive notif. then object parameter needs to be nil
        NSNotificationCenter.defaultCenter().addObserverForName( Notifications.AppModel, object: nil, queue: NSOperationQueue.mainQueue()) {
            [weak self] (notification) in
            self?.updateUI()
        }
        //need to initialize the model as TextListModel -- accepts its polymorphism
        model = RoundMenuModel()
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //        <#code#>
    //    }
    
    //Design mistake: lack the event handler for the bar searching
    //Also a glitch of the search bar is not resigning because of untyping the delegate 
    //of UISearchBar --> need inherit UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //update the searchText to the current filter
        model.currentFilter = searchText
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numSections(); // simple value at the moment--> Develop the Round model to know the exact value
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // arbitrary number at the moment--> Develop the Round model to know the exact value
        guard let numRows = model.numOfElementsInSection(section) else {
            preconditionFailure("Unable to get the value from the request section: \(section)")
        }
        return numRows
    }
    
    //Design prone: unable to display the section name because of lacking this func- titleForHeaderInSection
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sectionNameFromIndex(section)
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(RoundSearchVC.RoundSearchCellID) else {
            preconditionFailure("No such cell existed with an identifier: \(RoundSearchVC.RoundSearchCellID))")
        }
        //get the the model value in terms of section and index
        let modelValue = model.valueFromSection(indexPath.section, atIndex: indexPath.row)?.description
        cell.textLabel!.text = modelValue
        return cell
    }
}




