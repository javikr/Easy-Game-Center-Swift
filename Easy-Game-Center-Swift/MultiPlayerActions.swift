//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit
import GameKit

class MultiPlayerActions: UIViewController,EGCDelegate {
    
    @IBOutlet weak var TextLabel: UILabel!
    /*####################################################################################################*/
    /*                                          viewDidLoad                                               */
    /*####################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    @IBAction func ActionFindPlayer(sender: AnyObject) {
        EGC.findMatchWithMinPlayers(2, maxPlayers: 4)
    }
    
    @IBAction func ActionSendData(sender: AnyObject) {
        
        let myStruct = Packet(name: "My Data to Send !", index: 1234567890, numberOfPackets: 1)
        EGC.sendDataToAllPlayers(myStruct.archive(), modeSend: .Reliable)
        
    }
    @IBAction func ActionGetPlayerInMatch(sender: AnyObject) {
        if let setOfPlayer = EGC.getPlayerInMatch() {
            for player in setOfPlayer{
                print(player.alias)
            }
        }
    }
    @IBAction func ActionGetMatch(sender: AnyObject) {
        if let match = EGC.getMatch() {
            print(match, terminator: "")
        }
    }
    @IBAction func ActionDisconnected(sender: AnyObject) {
        EGC.disconnectMatch()
    }
    /*####################################################################################################*/
    /*                         Delegate Mutliplayer Easy Game Center                                      */
    /*####################################################################################################*/
    /**
    Match Start, Delegate Func of Easy Game Center
    */
    func EGCMatchStarted() {
        print("\n[MultiPlayerActions] MatchStarted")
        if let players = EGC.getPlayerInMatch() {
            for player in players{
                print(player.alias)
            }
        }
        self.TextLabel.text = "Match Started !"
    }
    /**
    Match Recept Data (When you send Data this function is call in the same time), Delegate Func of Easy Game Center
    */
    func EGCMatchRecept(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        
        // See Packet
        let autre =  Packet.unarchive(data)
        print("\n[MultiPlayerActions] Recept From player = \(playerID)")
        print("\n[MultiPlayerActions] Recept Packet.name = \(autre.name)")
        print("\n[MultiPlayerActions] Recept Packet.index = \(autre.index)")
        
        self.TextLabel.text = "Recept Date From \(playerID)"
    }
    /**
    Match End / Error (No NetWork example), Delegate Func of Easy Game Center
    */
    func EGCMatchEnded() {
        print("\n[MultiPlayerActions] MatchEnded")
        self.TextLabel.text = "Match Ended !"
    }
    /**
    Match Cancel, Delegate Func of Easy Game Center
    */
    func EGCMatchCancel() {
        print("\n[MultiPlayerActions] Match cancel")
    }
    
}

