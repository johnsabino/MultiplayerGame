//
//  Networking.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 19/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

struct MessageData {
    var isJumping: Bool
    var position: CGPoint
    
    init(isJumping: Bool, position: CGPoint) {
        self.isJumping = isJumping
        self.position = position
    }
    
    init() {
        self.isJumping = false
        self.position = CGPoint.zero
    }
    
    //Struct to data
    func archive() -> Data{
        var d = self
        return Data(bytes: &d, count: MemoryLayout.size(ofValue: d))
    }
    
    //Data to struct(nao entendi, só peguei no stackoverflow e funcionou)
    static func unarchive(_ d: Data) -> MessageData{
        guard d.count == MemoryLayout<MessageData>.stride else {
            fatalError("Error!")
        }
        
        var messageData = MessageData()
        
        d.withUnsafeBytes({(bytes: UnsafePointer<MessageData>) -> Void in
            messageData = UnsafePointer<MessageData>(bytes).pointee
        })
        return messageData
    }

}

class Networking {
    static let shared = Networking()
    
    
    func sendData(data : MessageData){
        do {
            let d = data.archive()
            //let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try GameCenterHelper.shared.currentMatch?.sendData(toAllPlayers: d, with: .reliable)
        } catch {
            print("error while archive data: \(error)")
        }
        
    }
    
}
