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
    @IBOutlet weak var PlayerProfil: UIImageView!
    
    /*####################################################################################################*/
    /*                       in ViewDidLoad, Set Delegate UIViewController                                */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Easy Game Center"
        
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
        Set New view controller delegate, when you change UIViewController
        */
       //EasyGameCenter.delegate = self
        
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
        
        EasyGameCenter.getlocalPlayerInformation {
            (playerInformationTuple) -> () in
            //playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
            
            if let typleInformationPlayer = playerInformationTuple {
                
                self.PlayerID.text = "Player ID : \(typleInformationPlayer.playerID)"
                self.Name.text = "Name : \(typleInformationPlayer.alias)"
                self.PlayerAuthentified.text = "Player Authentified : True"
                
                if let haveProfilPhoto = typleInformationPlayer.profilPhoto {
                    self.PlayerProfil.image = haveProfilPhoto
                }
                
            }
        }
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
                println("\n[MainViewController] Game Center Achievements Is show\n")
            }
        }
        
    }
    @IBAction func ShowGameCenterLeaderboards(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement") { (isShow) -> Void in
            println("\n[MainViewController] Game Center Leaderboards Is show\n")
        }
    }
    @IBAction func ShowGameCenterChallenges(sender: AnyObject) {
        EasyGameCenter.showGameCenterChallenges {
            (result) -> Void in
            if result {
                println("\n[MainViewController] Game Center Challenges Is show\n")
            }
            
        }
        
    }
    @IBAction func ShowCustomBanner(sender: AnyObject) {
        
        EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { () -> Void in
            println("\n[MainViewController] Custom Banner is finish to Show\n")
        }
    }
    @IBAction func ActionOpenDialog(sender: AnyObject) {
        EasyGameCenter.openDialogGameCenterAuthentication(title: "Open Game Center", message: "Open Game Center authentification ?", buttonOK: "No", buttonOpenGameCenterLogin: "Yes") {
            (openGameCenterAuthentification) -> Void in
            if openGameCenterAuthentification {
                println("\n[MainViewController] Open Game Center Authentification\n")
            } else {
                println("\n[MainViewController] Not open Game Center Authentification\n")
            }
        }
    }
}

