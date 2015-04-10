//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit


/*####################################################################################################*/
/*                              Add >>> EasyGameCenterDelegate <<< for delegate                       */
/*####################################################################################################*/
class MainViewController: UIViewController,EasyGameCenterDelegate {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PlayerID: UILabel!
    @IBOutlet weak var PlayerAuthentified: UILabel!
    
    /*####################################################################################################*/
    /*                       in ViewDidLoad, Set Delegate UIViewController                                */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Easy Game Center"
        
        /**
        Set Delegate UIViewController
        */
        EasyGameCenter.sharedInstance(self)
        
        /** If you want not message just delete this ligne **/
        EasyGameCenter.debugMode = true
        
        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
        Set New view controller delegate, when you change UIViewController
        */
        EasyGameCenter.delegate = self
        
        /* Recall if you change page and activate network for refresh text*/
        if EasyGameCenter.isPlayerIdentifiedToGameCenter() {
            easyGameCenterAuthentified()
        }
    }
    /*####################################################################################################*/
    /*                               Delegate Func Easy Game Center                                       */
    /*####################################################################################################*/
    /**
    Player conected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterAuthentified() {
        
        println("\n[MainViewController] Player Authentified\n")
        
        let localPlayer = EasyGameCenter.getLocalPlayer()
        self.PlayerID.text = "Player ID : \(localPlayer.playerID)"
        self.Name.text = "Name : \(localPlayer.alias)"
        self.PlayerAuthentified.text = "Player Authentified : True"
        
    }
    /**
    Player not connected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterNotAuthentified() {
        println("\n[MainViewController] Player not authentified\n")
        self.PlayerAuthentified.text = "Player Authentified : False"
    }
    /**
    When GkAchievement & GKAchievementDescription in cache, Delegate Func of Easy Game Center
    */
    func easyGameCenterInCache() {
        println("\n[MainViewController] GkAchievement & GKAchievementDescription in cache\n")
        
    }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func ShowGameCenterAchievements(sender: AnyObject) {
        EasyGameCenter.showGameCenterAchievements { (isShow) -> Void in
            if isShow {
                println("Game Center Achievements Is show")
            }
        }
        
    }
    @IBAction func ShowGameCenterLeaderboards(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement") { (isShow) -> Void in
            println("Game Center Leaderboards Is show")
        }
    }
    @IBAction func ShowGameCenterChallenges(sender: AnyObject) {
        EasyGameCenter.showGameCenterChallenges {
            (result) -> Void in
            if result {
               println("Game Center Challenges Is show")
            }
            
        }
        
    }

    @IBAction func ShowCustomBanner(sender: AnyObject) {
        
        EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { () -> Void in
            println("Custom Banner is finish to Show")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionOpenDialog(sender: AnyObject) {
        EasyGameCenter.openDialogGameCenterAuthentication(title: "Open Game Center", message: "Open Game Center authentification ?", buttonOK: "No", buttonOpenGameCenterLogin: "Yes") {
            (openGameCenterAuthentification) -> Void in
            if openGameCenterAuthentification {
                println("Open Game Center Authentification")
            } else {
                println("Not open Game Center Authentification")
            }
        }
    }
    
    
}

