//
//  AppDelegate.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /**
        Set Delegate UIViewController
        */
       // EasyGameCenter.sharedInstance()
        
        /** If you want not message just delete this ligne **/
        EasyGameCenter.debugMode = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    /**
        Simple Message
    
        :param: title            Title
        :param: message          Message
        :param: uiViewController UIViewController
    */
    class func simpleMessage(#title:String, message:String, uiViewController:UIViewController) {
        if ( objc_getClass("UIAlertController") != nil ) {
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            uiViewController.presentViewController(alert, animated: true, completion: nil)
        } else {
            var alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = title
            alert.message = message
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
}

