//
//  DebuggingVC.swift
//  Restaurant Bill
//
//  Created by Trungski Ngo-Goldberg on 7/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

//MARK:
struct SegueSettings {
    static let animationSpeed = 0.05
}

//MARK: Supportive alert message ready to use in all view controllers 
extension UIViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}


//MARK: extension for UIStoryboard
extension UIStoryboard {
    static func make (ViewControllerID: String, from: String = "Main") -> UIViewController {
        let board = UIStoryboard(name: from, bundle: nil)
        //Bug: Could not find a storyboard named 'HomeVC'-> instantiate from the Main.storyboard not another VC ID
        return board.instantiateViewControllerWithIdentifier(ViewControllerID)
    }
}


//MARK: Util class for the message log in the debuggingVC
class Util {
    static func log(message: String, sourceAbsolutePath: String = #file, line: Int = #line, function: String = #function) {
        let threadType = NSThread.currentThread().isMainThread ? "main" : "other"
        let baseName = (NSURL(fileURLWithPath: sourceAbsolutePath).lastPathComponent! as NSString).stringByDeletingPathExtension ?? "UNKNOWN_FILE"
        print("\(NSDate()) \(threadType) \(baseName) \(function)[\(line)]: \(message)")
    }
}

class ObservingVC: UIViewController {
    /* Lifecycle magnifying glass */
    override func viewDidLoad() {
        Util.log("Enter: \(self.dynamicType)")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        Util.log("Enter: \(self.dynamicType)")
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        Util.log("Enter: \(self.dynamicType)")
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        Util.log("Enter: \(self.dynamicType)")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        Util.log("Enter: \(self.dynamicType)")
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        // Util.log("Enter: \(self.dynamicType)")
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        // Util.log("Enter: \(self.dynamicType)")
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        Util.log("Enter: \(self.dynamicType)")
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        Util.log("VIEW DEALLOCATED: \(self.dynamicType)")
    }
}
 