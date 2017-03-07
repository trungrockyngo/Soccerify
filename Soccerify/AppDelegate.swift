//
//  AppDelegate.swift
//  Final Project Storyboard Design
//
//  Created by Trungski Ngo-Goldberg on 7/18/16.
//  Copyright © 2016 Trungski Ngo-Goldberg. All rights reserved.
//

import UIKit

let AppDel = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //Design setback for asyn programming with a centralized model pool
    private var modelQueue: NSOperationQueue = {
        let mq = NSOperationQueue()
        mq.qualityOfService = .UserInitiated
        mq.maxConcurrentOperationCount = 1
        return mq
    }()
    
    //Design prone: should make the shared property of the application private (set) lazy var
    private (set) lazy var myCentralDataModel : DataManager = DataManager(opQueue: self.modelQueue)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
//    func applicationWillResignActive(application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    }
//    
//    func applicationDidEnterBackground(application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//    
//    func applicationWillEnterForeground(application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }
//    
//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        //        self.saveContext()
//    }
    
}

