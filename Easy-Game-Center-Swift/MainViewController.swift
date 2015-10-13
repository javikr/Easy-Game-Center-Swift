//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit


/*####################################################################################################*/
/*              for have delegate func Add >>> EGCDelegate <<< for delegate                */
/*                       If you not use do not add                                                    */
/*####################################################################################################*/
class MainViewController: UIViewController, EGCDelegate  {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PlayerID: UILabel!
    @IBOutlet weak var PlayerAuthentified: UILabel!
    @IBOutlet weak var PlayerProfil: UIImageView!
    
    /*####################################################################################################*/
    /*                       in ViewDidLoad, Set Delegate UIViewController                                */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Set Delegate UIViewController */
        EGC.sharedInstance(self)
        
        /** If you want not message just delete this ligne **/
        EGC.debugMode = true
        self.navigationItem.title = "Easy Game Center"
        
        /** Hidden automatique page for login to Game Center if player not login */
        //EGC.showLoginPage = false
        
        
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
        EGC.delegate = self
        
        /* Recall if you change page and activate network for refresh text
        if EGC.isPlayerIdentified {
            EGCAuthentified()
        }*/
    }
    /*####################################################################################################*/
    /*                               Delegate Func Easy Game Center                                       */
    /*####################################################################################################*/
    /**
    Player conected to Game Center, Delegate Func of Easy Game Center
    */
    func EGCAuthentified(authentified:Bool) {
        
        print("\n[MainViewController] Player Authentified = \(authentified)\n")
        
        if authentified {
            EGC.getlocalPlayerInformation {
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
            
        } else {
            self.PlayerID.text = "Player ID :"
            self.Name.text = "Name :"
            self.PlayerProfil.image = nil
            self.PlayerAuthentified.text = "Player Authentified : False"
        }

    }
    /**
    Player not connected to Game Center, Delegate Func of Easy Game Center
    */
    func EGCNotAuthentified() {
        print("\n[MainViewController] Player not authentified\n")
        self.PlayerAuthentified.text = "Player Authentified : False"
    }
    /**
    When GkAchievement & GKAchievementDescription in cache, Delegate Func of Easy Game Center
    */
    func EGCInCache() {
        print("\n[MainViewController] GkAchievement & GKAchievementDescription in cache\n")
    }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func ShowGameCenterAchievements(sender: AnyObject) {
        EGC.showGameCenterAchievements { (isShow) -> Void in
            if isShow {
                print("\n[MainViewController] Game Center Achievements Is show\n")
            }
        }
        
    }
    @IBAction func ShowGameCenterLeaderboards(sender: AnyObject) {
        
        EGC.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement") { (isShow) -> Void in
            print("\n[MainViewController] Game Center Leaderboards Is show\n")
        }
    }
    @IBAction func ShowGameCenterChallenges(sender: AnyObject) {
        EGC.showGameCenterChallenges {
            (result) -> Void in
            if result {
                print("\n[MainViewController] Game Center Challenges Is show\n")
            }
            
        }
        
    }
    @IBAction func ShowCustomBanner(sender: AnyObject) {
        
        EGC.showCustomBanner(title: "Title", description: "My Description...") { () -> Void in
            print("\n[MainViewController] Custom Banner is finish to Show\n")
        }
    }
    @IBAction func ActionOpenDialog(sender: AnyObject) {
        EGC.showGameCenterAuthentication({
            (resultOpenGameCenter) -> Void in
            
            print("\n[MainViewController] Show Game Center\n")
        })
    }
}

