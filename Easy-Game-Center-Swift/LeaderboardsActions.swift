//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class LeaderboardsActions: UIViewController {
    
    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBarOpenGameCenter :UIBarButtonItem =  UIBarButtonItem(title: "Game Center Leaderboards", style: .Bordered, target: self, action: "openGameCenterLeaderboard:")
        self.navigationItem.rightBarButtonItem = buttonBarOpenGameCenter
        
    }
    
    /*####################################################################################################*/
    /*    Set New view controller delegate, is when you change you change UIViewControlle                 */
    /*####################################################################################################*/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate */
        EGC.delegate = self
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func openGameCenterLeaderboard(sender: AnyObject) {
        
        EGC.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement", completion: {
            (result) -> Void in
            if result {
                print("\n[LeaderboardsActions] You open Game Center Achievements")
            }
        })
    }
    
    @IBAction func ActionReportScoreLeaderboard(sender: AnyObject) {
        
        EGC.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100)
        print("\n[LeaderboardsActions] Score send to Game Center \(EGC.isPlayerIdentified)")
        
    }
    
    @IBAction func ActionGetLeaderboards(sender: AnyObject) {
        
        EGC.getGKLeaderboard {
            (resultArrayGKLeaderboard) -> Void in
            if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard {
                for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                    
                    print("\n[LeaderboardsActions] Get Leaderboards (getGKLeaderboard)\n")
                    print("ID : \(oneGKLeaderboard.identifier)\n")
                    print("Title :\(oneGKLeaderboard.title)\n")
                    print("Loading ? : \(oneGKLeaderboard.loading)\n")
                    
                }
            }
        }
    }
    
    @IBAction func ActionGetGKScoreLeaderboard(sender: AnyObject) {
        
        EGC.getGKScoreLeaderboard(leaderboardIdentifier: "International_Classement") {
            (resultGKScore) -> Void in
            if let resultGKScoreIsOK = resultGKScore as GKScore? {
                
                print("\n[LeaderboardsActions] Get GKScore Leaderboard (getGKScoreLeaderboard)\n")
                print("Leaderboard Identifier : \(resultGKScoreIsOK.leaderboardIdentifier)\n")
                print("Date : \(resultGKScoreIsOK.date)\n")
                print("Rank :\(resultGKScoreIsOK.rank)\n")
                print("Hight Score : \(resultGKScoreIsOK.value)\n")
            }
        }
    }
    
    @IBAction func GetHighScore(sender: AnyObject) {
        EGC.getHighScore(leaderboardIdentifier: "International_Classement") {
            (tupleHighScore) -> Void in
            /// tupleHighScore = (playerName:String, score:Int,rank:Int)?
            if let tupleIsOk = tupleHighScore {
                print("\n[LeaderboardsActions] Get Hight Score (getHighScore)\n")
                print("Player Name : \(tupleIsOk.playerName)\n")
                print("Score : \(tupleIsOk.score)\n")
                print("Rank :\(tupleIsOk.rank)\n")
            }
        }
    }
    @IBAction func Test(sender: AnyObject) {
        /*let instance = EGC.sharedInstance(self)
        
        instance.findMatchWithMinPlayers(2, maxPlayers: 4)*/
    }
}

