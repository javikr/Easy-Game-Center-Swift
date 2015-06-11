//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class AchievementsActions: UIViewController {
    
    @IBOutlet weak var AchievementsNumber: UILabel!
    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Achievement", style: .Bordered, target: self, action: "openGameCenterAchievement:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter
        
        
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            
            if let arrayAchievementDescription = arrayGKAD {
                self.AchievementsNumber.text = "Number Achievements :  \(arrayAchievementDescription.count)"
            }
        }
    }
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EasyGameCenter.delegate = self
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func openGameCenterAchievement(sender: AnyObject) {
        EasyGameCenter.showGameCenterAchievements { (isShow) -> Void in
            print("\n[AchievementsActions] You open Game Center Achievements\n")
        }
    }
    
    @IBAction func ActionGetAchievementsDescription(sender: AnyObject) {
        
        EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: "Achievement_One") { (tupleGKAchievementAndDescription) -> Void in
            
            if let tupleInfoAchievement = tupleGKAchievementAndDescription {
                
                let gkAchievementDescription = tupleInfoAchievement.gkAchievementDescription
                let gkAchievement = tupleInfoAchievement.gkAchievement
                print("\n[AchievementsActions] Achievement Description")
                // The title of the achievement.
                print("Title : \(gkAchievementDescription.title)\n")
                // Whether or not the achievement should be listed or displayed if not yet unhidden by the game.
                print("Hidden? : \(gkAchievement.identifier)\n")
                // The description for an unachieved achievement.
                print("Achieved Description : \(gkAchievementDescription.achievedDescription)\n")
                // The description for an achieved achievement.
                print("Unachieved Description : \(gkAchievementDescription.unachievedDescription)\n")
            }
        }
    }
    
    @IBAction func ReportAchievementOne(sender: AnyObject) {
        EasyGameCenter.reportAchievement(progress: 100.00, achievementIdentifier: "Achievement_One")
    }
    
    @IBAction func IfAchievementIsFinished(sender: AnyObject) {
        
        let achievementOneCompleted = EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Achievement_One")
        if achievementOneCompleted {
            AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Yes", uiViewController: self)
        } else {
            if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "No", uiViewController: self)
            } else {
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Player not identified", uiViewController: self)
            }
        }
    }
    
    @IBAction func ReportAchievementTwo(sender: AnyObject) {
        
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            if EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Achievement_Two") {
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Achievement is already report", uiViewController: self)
                
            } else {
                EasyGameCenter.reportAchievement(progress: 100.00, achievementIdentifier: "Achievement_Two", showBannnerIfCompleted: false)
                AppDelegate.simpleMessage(title: "isAchievementCompleted", message: "Achievement is reported, but banner not show", uiViewController: self)
            }

        } else {
            AppDelegate.simpleMessage(title: "report Achievements fail", message: "Player not login", uiViewController: self)
        }
    }
    
    @IBAction func AchievementCompletedAndNotShowing(sender: AnyObject) {
        
        if let achievements : [GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
            for oneAchievement in achievements  {
                print("\n[AchievementsActions] Achievement Completed And NotShowing \n")
                print("\(oneAchievement.identifier)\n")
            }
        } else {
            print("\n[AchievementsActions] NO Achievement with not showing\n")
        }
    }
    
    @IBAction func ShowAchievementCompletedAndNotShowing(sender: AnyObject) {
        EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing()
    }
    
    @IBAction func GetAllChievementsDescription(sender: AnyObject) {
        
        EasyGameCenter.getGKAllAchievementDescription {
            (arrayGKAD) -> Void in
            if let arrayAchievementDescription = arrayGKAD {
                for achievement in arrayAchievementDescription {
                    print("\n[AchievementsActions] Get All Achievements Description\n")
                    print("ID : \(achievement.identifier)\n")
                    // The title of the achievement.
                    print("Title : \(achievement.title)\n")
                    // Whether or not the achievement should be listed or displayed if not yet unhidden by the game.
                    print("Hidden? : \(achievement.hidden)\n")
                    // The description for an unachieved achievement.
                    print("Achieved Description : \(achievement.achievedDescription)\n")
                    // The description for an achieved achievement.
                    print("Unachieved Description : \(achievement.unachievedDescription)\n")
                }
            }
        }
    }
    
    @IBAction func ResetAllAchievements(sender: AnyObject) {
        EasyGameCenter.resetAllAchievements()
    }
}

