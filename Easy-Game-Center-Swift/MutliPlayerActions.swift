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
    /*####################################################################################################
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
        let instance = EasyGameCenter.sharedInstance(self)
        
        instance.findMatchWithMinPlayers(2, maxPlayers: 4)
    }

    @IBAction func ActionSendData(sender: AnyObject) {
        let instance = EasyGameCenter.sharedInstance(self)
        
        //let send = SendDate(messageEnvoi: "ok")
        
        
        var myStruct = Packet(name: "ok", index: 1, numberOfPackets: 1)//, data: nil
        

      
        //var b = NSData(bytesNoCopy: &a, length: sizeof(DEMO),freeWhenDone:false)
        
        let success = instance.match.sendDataToAllPlayers(myStruct.archive(), withDataMode: .Reliable, error: nil)
        if !success {
            println("An unknown error occured while sending data")
        } else {
            println("Send Succes")
        }
    }
    func matchStarted() {
        println("matchStarted")
    }
    func matchEnded() {
        println("matchEnded")
    }
    func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        

        
        let autre =  Packet.unarchive(data)
        println(autre.name)
        println(autre.index)
        println(match)
        println(playerID)
    }
    
    struct Packet {
        var name: String
        var index: Int64
        var numberOfPackets: Int64
       // var data: NSData
        
        struct ArchivedPacket {
            var index : Int64
            var numberOfPackets : Int64
            var nameLength : Int64
          //  var dataLength : Int64
        }
        
        func archive() -> NSData {
            
            var archivedPacket = ArchivedPacket(index: Int64(self.index), numberOfPackets: Int64(self.numberOfPackets), nameLength: Int64(self.name.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
            
            //, dataLength: Int64(self.data.length)
            
            var metadata = NSData(
                bytes: &archivedPacket,
                length: sizeof(ArchivedPacket)
            )
            
            let archivedData = NSMutableData(data: metadata)
            archivedData.appendData(name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            //archivedData.appendData(data)
            
            return archivedData
        }
        
        static func unarchive(data: NSData!) -> Packet {
            var archivedPacket = ArchivedPacket(index: 0, numberOfPackets: 0, nameLength: 0) //, dataLength: 0
            let archivedStructLength = sizeof(ArchivedPacket)
            
            let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
            archivedData.getBytes(&archivedPacket)
            
            let nameRange = NSMakeRange(archivedStructLength, Int(archivedPacket.nameLength))
            //let dataRange = NSMakeRange(archivedStructLength + Int(archivedPacket.nameLength), Int(archivedPacket.dataLength))
            
            let nameData = data.subdataWithRange(nameRange)
            let name = NSString(data: nameData, encoding: NSUTF8StringEncoding) as! String
           // let theData = data.subdataWithRange(dataRange)
            
            let packet = Packet(name: name, index: archivedPacket.index, numberOfPackets: archivedPacket.numberOfPackets)
            //, data: theData
            
            return packet
        }
    }
    

    /*####################################################################################################*/
    /*                                          Multi                                                    */
    /*####################################################################################################*/
    */
}

