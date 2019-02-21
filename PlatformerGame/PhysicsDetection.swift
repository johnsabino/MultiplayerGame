//
//  PhysicsDetection.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 17/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let player: UInt32 = 0x1 << 0 // 000000001 = 1
    static let ground: UInt32 = 0x1 << 1 // 000000010 = 2 // 000000100 = 4
    static let all: UInt32 = UInt32.max // collide with all
}

class PhysicsDetection: NSObject, SKPhysicsContactDelegate {
    //var player: CharacterNode?
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("bodyA:", contact.bodyA.node?.name ?? "nil", "bodyB: ", contact.bodyB.node?.name ?? "nil")
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        //if the collision was between player and ground
        if collision == ColliderType.player | ColliderType.ground {
            if let player = contact.bodyA.node as? CharacterNode {
                player.grounded = true
            }else if let player = contact.bodyB.node as? CharacterNode{
                player.grounded = true
            }
            
            
        }
        if collision == ColliderType.player | ColliderType.player {
            print("collision between players")
        }
        

    }
    


}
