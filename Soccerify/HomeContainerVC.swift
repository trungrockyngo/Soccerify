//
//  HomeContainerVC.swift
//  Final Project Storyboard Design
//
//  Created by Trungski Ngo-Goldberg on 7/26/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit

struct NavigationBarBackground {
    static let BackgroundColor
        = UIColor(colorLiteralRed: 6/255.0, green: 15/255.0, blue: 30/255.0, alpha: 1.0)
}

//MARK: Set up the size for the slide-out margin
struct Sizes {
    static let SettingsScreenMargin: CGFloat = 30.0
}

//MARK: struct of subchild VC in the home container VC
struct HomeViewControllers{
    static let RoundSearchVC = "RoundSearchVC"
    static let HomeVC = "HomeVC"
}

class HomeContainerVC: UIViewController {
    private let homeVC = UIStoryboard.make(HomeViewControllers.HomeVC)
        as! HomeVC
    private let leftVC = UIStoryboard.make(HomeViewControllers.RoundSearchVC)
        as! RoundSearchVC
    private let leftShowing = false
    
    //Navigation Controller without its initializer -decides which VC is a navigation controller will cease to the error -- it prevents synthesizer
    private var navVC: UINavigationController!
    
    @IBAction func settingsTapped(user: AnyObject){
        //if clicking on the top left-- minX
        if navVC.view.frame.minX == 0
        {
            //slide right to get back to HomeVC
            slideLeft(true)
            leftVC.view.hidden = false
            navVC.view.layer.shadowOffset = CGSize(width: -3.0, height: -3.0)
        }
        else {
            slideLeft(false)
        }
    }
    
    override func viewDidLoad() {
        addChildViewController(leftVC)
        leftVC.didMoveToParentViewController(self)
        view.addSubview(leftVC.view)
        
        //create programmatically the bar button for the HomeVC
        homeVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Round Menu"), style: .Plain, target: self, action: #selector(HomeContainerVC.settingsTapped(_:)))
        
        //MARK: nav controller as HomeVC add childViewController, add subview
        navVC = UINavigationController(rootViewController: homeVC)
        
        navVC.view.layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        navVC.view.layer.shadowOpacity = 0.5
        navVC.view.layer.shadowRadius = 5.0
        navVC.view.clipsToBounds = false
        
        addChildViewController(navVC)
        navVC.didMoveToParentViewController(navVC)
        view.addSubview(navVC.view)
        
    }
    
    private func slideLeft(pushAside: Bool){
        //disable the view interaction and customize slide-out animation
        homeVC.view.userInteractionEnabled = !pushAside
        UIView.animateWithDuration(0.05){
            [unowned self] in
            let xDist = (pushAside ? 1: -1) * (self.view.frame.width -
                Sizes.SettingsScreenMargin)
            self.navVC.view.frame.offsetInPlace(dx: xDist, dy: 0.0)
        }
    }
}