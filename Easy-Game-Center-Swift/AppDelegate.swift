//
//  AppDelegate.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//
// 

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    /**
    Tells the delegate that the launch process
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
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
    class func simpleMessage(title title:String, message:String, uiViewController:UIViewController) {
         if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            uiViewController.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = title
            alert.message = message
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
}

