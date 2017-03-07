//
//  StadiumMapVC.swift
//  Soccerify
//
//  Created by Trungski Ngo-Goldberg on 7/31/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit
import MapKit

let MissingError = "Error not available"
let pinReuseID = "pin"

//MARK: abstract the location/place annotation customized MKAnnotation
class PlaceAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?  //Used for the stadium's title later when the data model is come in
    var subtitle: String? //maybe used for its description ???
    
    init( coordinate: CLLocationCoordinate2D, title: String?, subtitle: String? ){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

struct MatchStadiumSettings {
//    static let Coordinate = 
}

class StadiumMapVC: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    static let StadiumStadiumMapVCID = "Stadium Map VC"
    
    //modify to change the initial location
    static let StadiumLocation = CLLocationCoordinate2DMake(48.924375, -71.820005)
    
    var myLocation: CLLocation?
    @IBOutlet weak var searchBar: UISearchBar!
    //    var searchBar: UISearchBar!
    var locationManager: CLLocationManager?
    var localSearch: MKLocalSearch?
    
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet {
            //setup the initial location
            let initalLocation = MKCoordinateRegion(center: StadiumMapVC.StadiumLocation, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
            mapView.setRegion(initalLocation, animated: false)
        }
    }
    
    //MARK: Fix the condensed width of the segment control in the toolbar: add constraint Preserve SuperView Margins
    @IBOutlet weak var mapDisplaySettings: UISegmentedControl!
    
    //MARK: change the map view type when the segment control state is changed
    @IBAction func displayMapView(sender: AnyObject) {
        let settingStateIndex = mapDisplaySettings.selectedSegmentIndex
        switch settingStateIndex {
        case 0:
            mapView.mapType = MKMapType.Standard
            break;
        case 1:
            mapView.mapType = MKMapType.Satellite
            break;
        case 2:
            mapView.mapType = MKMapType.Hybrid
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        //add programmatic navigation bar
        guard (self.navigationController?.navigationItem.backBarButtonItem) != nil
            else {
            return
        }
        self.navigationItem.title = "Stadium Location"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //request the user's current location while the app is in foreground
        locationManager?.requestWhenInUseAuthorization()
        
        //request one-time current user location, especially for the sake of getting rid of temporary error message complained by the current location, request the location after the view appears
        locationManager?.requestLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            //then show user location
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        print("The updated location: \(myLocation)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("The location is invalid to be retrieved, because of \(error.description)")
    }
    
    func updateMapWithItem (item: MKMapItem, region: MKCoordinateRegion){
        //extract the location from the item and then its name to manipulate its geo data, distance and initalize its annotation
        guard let location = item.placemark.location else {
            print("No location for item, was this set from the user's current location?")
            return
        }
        guard let name = item.name else {
            print("Item missing its name - search error!")
            return
        }
        let geoLoc = location.coordinate
        print("The location updated is \(geoLoc.latitude), \(geoLoc.longitude)")
        
        let dist: String
        if let myLoc = myLocation{
            dist = "\(myLoc.distanceFromLocation(location)/1000)km"
        }
        else {
            dist = "Distance unknown"
        }
        let annotation = PlaceAnnotation(coordinate: geoLoc, title: name, subtitle: "\(geoLoc) Distance: \(dist)")
        mapView.addAnnotation(annotation)
        
        //the app's inablity to update the new region due to lack of setting this region in map view
        mapView.setRegion(region, animated: true)
        
        //add extended feature of snapping the map using annotations
    }
    
    //MARK: Life-cycle further implementation needed during vidwDidLoad(), due to the complexity of initialization sequence
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        guard isViewLoaded() else {
            return
        }
        //then resign the search bar and deselect every annotation in the collection
        searchBar.resignFirstResponder()
        for annotation in mapView.annotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("The current region now is \(mapView.region)")
    }
    
    //return the map view with specified annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation){
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let pinViewID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinViewID)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: pinViewID)
            pinView?.canShowCallout = true //ensure the pinView show extra info in a callout bubble
        }
        //custom design of view pin
        pinView?.tintColor = UIColor.greenColor()
        pinView?.annotation = annotation
        return pinView
    }
    
    func snapMapUsingAnnotations() {
        var minLat = 1000.0
        var maxLat = -1000.0
        var minLng = 1000.0
        var maxLng = -1000.0
        
        // Calculate bounding region out of cumulative search results
        for item in mapView.annotations {
            minLat = min(minLat, item.coordinate.latitude)
            maxLat = max(maxLat, item.coordinate.latitude)
            minLng = min(minLng, item.coordinate.longitude)
            maxLng = max(maxLng, item.coordinate.longitude)
        }
        
        let latRange = maxLat - minLat
        let lngRange = maxLng - minLng
        
        // Adjust span so pins on edge have a comfortable margin
        minLat -= latRange / 10.0
        maxLat += latRange / 10.0
        minLng -= lngRange / 10.0
        maxLng += lngRange / 10.0
        
        let span = MKCoordinateSpanMake(maxLat - minLat, maxLng - minLng)
        
        let center = CLLocationCoordinate2DMake(minLat + span.latitudeDelta / 2.0, minLng + span.longitudeDelta / 2.0)
        
        mapView.setRegion(MKCoordinateRegionMake(center, span), animated: true)
    }
    
    
    //MARK: faciliate the searching and updating to the searched location
    func searchBarSearchButtonClicked (searchBar: UISearchBar){
        //get the current search's request after being processed by the natural language query. Then faciliate the search to receive its result by the asynchronous callback
        //here check if local search existed, it then cancel the search
        if let search = localSearch {
            search.cancel()
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        
        localSearch = MKLocalSearch(request: request)
        //set the network activity visible
        UIApplication.sharedApplication()
            .networkActivityIndicatorVisible = true
        
        //start the search and deliver the response with error handling asynchronously
        localSearch!.startWithCompletionHandler {
            [weak self] (response : MKLocalSearchResponse?, error: NSError?)in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            //safely extract location search results based on response
            guard let myResponse = response else {
                print("error in search: \(error?.localizedDescription ?? MissingError)")
                return
            }
            guard let location = myResponse.mapItems.first else {
                print("There are no results")
                return
            }
            self?.updateMapWithItem(location, region: myResponse.boundingRegion)
        }
    }
}
