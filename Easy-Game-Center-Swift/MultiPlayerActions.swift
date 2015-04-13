//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class MultiPlayerActions: UIViewController {
    
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
    @IBAction func ActionFindPlayer(sender: AnyObject) {
        EasyGameCenter.findMatchWithMinPlayers(2, maxPlayers: 4)
    }

    @IBAction func ActionSendData(sender: AnyObject) {
        
        var myStruct = Packet(name: "My Data to Send !", index: 1234567890, numberOfPackets: 1)
        EasyGameCenter.sendDataToAllPlayers(myStruct.archive(), modeSend: .Reliable)

    }
    /*####################################################################################################*/
    /*                         Delegate Mutliplayer Easy Game Center                                      */
    /*####################################################################################################*/
    /**
    Match Start, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchStarted() {
        println("\n[MultiPlayerActions] MatchStarted")
        if let players = EasyGameCenter.getPlayerInMatch() {
            for player in players{
                println(player.alias)
            }
        }
    }
    /**
    Match Recept Data (When you send Data this function is call in the same time), Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchRecept(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        
        // See Packet
        let autre =  Packet.unarchive(data)
        println("\n[MultiPlayerActions] Recept From player = \(playerID)")
        println("\n[MultiPlayerActions] Recept Packet.name = \(autre.name)")
        println("\n[MultiPlayerActions] Recept Packet.index = \(autre.index)")
    }
    /**
    Match End / Error (No NetWork example), Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchEnded() {
        println("\n[MultiPlayerActions] MatchEnded")
    }
    /**
    Match Cancel, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchCancel() {
        println("\n[MultiPlayerActions] Match cancel")
    }

}

