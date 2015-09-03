//
//  Packet.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 13/04/2015.
//  Copyright (c) 2015 DaRk-_-D0G. All rights reserved.
//

import Foundation
/**
*  Packet
*/
struct Packet {
    var name: String
    var index: Int64
    var numberOfPackets: Int64
    
    /**
    *  Struc
    */
    struct ArchivedPacket {
        var index : Int64
        var numberOfPackets : Int64
        var nameLength : Int64
    }
    /**
    Archive Packet
    
    - returns: NSData
    */
    func archive() -> NSData {
        
        var archivedPacket = ArchivedPacket(index: Int64(self.index), numberOfPackets: Int64(self.numberOfPackets), nameLength: Int64(self.name.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        
        let metadata = NSData(
            bytes: &archivedPacket,
            length: sizeof(ArchivedPacket)
        )
        
        let archivedData = NSMutableData(data: metadata)
        archivedData.appendData(name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        
        return archivedData
    }
    /**
    Unarchive Packet
    
    - parameter data: NSData
    
    - returns: Packet
    */
    static func unarchive(data: NSData!) -> Packet {
        var archivedPacket = ArchivedPacket(index: 0, numberOfPackets: 0, nameLength: 0) //, dataLength: 0
        let archivedStructLength = sizeof(ArchivedPacket)
        
        let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
        archivedData.getBytes(&archivedPacket)
        
        let nameRange = NSMakeRange(archivedStructLength, Int(archivedPacket.nameLength))
        let nameData = data.subdataWithRange(nameRange)
        let name = NSString(data: nameData, encoding: NSUTF8StringEncoding) as! String
        let packet = Packet(name: name, index: archivedPacket.index, numberOfPackets: archivedPacket.numberOfPackets)
        
        return packet
    }
}