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
        EasyGameCenter.delegate = self
    }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    /*####################################################################################################*/
    /*                                          Button                                                    */
    /*####################################################################################################*/
    @IBAction func openGameCenterLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "International_Classement", completion: {
            (result) -> Void in
            if result {
                println("\n[LeaderboardsActions] You open Game Center Achievements")
            }
        })
    }
    
    @IBAction func ActionReportScoreLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "International_Classement", score: 100)
        println("\n[LeaderboardsActions] Score send to Game Center \(EasyGameCenter.isPlayerIdentifiedToGameCenter())")
        
    }
    
    @IBAction func ActionGetLeaderboards(sender: AnyObject) {
        
        EasyGameCenter.getGKLeaderboard {
            (resultArrayGKLeaderboard) -> Void in
            if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
                for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                    
                    println("\n[LeaderboardsActions] Get Leaderboards (getGKLeaderboard)\n")
                    println("ID : \(oneGKLeaderboard.identifier)\n")
                    println("Title :\(oneGKLeaderboard.title)\n")
                    println("Loading ? : \(oneGKLeaderboard.loading)\n")
                    
                }
            }
        }
    }
    
    @IBAction func ActionGetGKScoreLeaderboard(sender: AnyObject) {
        
        EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: "International_Classement") {
            (resultGKScore) -> Void in
            if let resultGKScoreIsOK = resultGKScore as GKScore? {
                
                println("\n[LeaderboardsActions] Get GKScore Leaderboard (getGKScoreLeaderboard)\n")
                println("Leaderboard Identifier : \(resultGKScoreIsOK.leaderboardIdentifier)\n")
                println("Date : \(resultGKScoreIsOK.date)\n")
                println("Rank :\(resultGKScoreIsOK.rank)\n")
                println("Hight Score : \(resultGKScoreIsOK.value)\n")
            }
        }
    }
    
    @IBAction func GetHighScore(sender: AnyObject) {
        EasyGameCenter.getHighScore(leaderboardIdentifier: "International_Classement") {
            (tupleHighScore) -> Void in
            /// tupleHighScore = (playerName:String, score:Int,rank:Int)?
            if let tupleIsOk = tupleHighScore {
                println("\n[LeaderboardsActions] Get Hight Score (getHighScore)\n")
                println("Player Name : \(tupleIsOk.playerName)\n")
                println("Score : \(tupleIsOk.score)\n")
                println("Rank :\(tupleIsOk.rank)\n")
            }
        }
    }   
}

