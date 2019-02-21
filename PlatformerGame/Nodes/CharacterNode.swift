//
//  CharacterNode.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 16/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameplayKit

class CharacterNode: SKSpriteNode {

    var grounded = false
    let jumpImpuse: CGFloat = 60.0
    let playerSpeed: CGFloat = 0.2
    var playerID: String?
    
    func setupPlayer(playerID: String){
        
            self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
            self.physicsBody?.allowsRotation = false

            self.physicsBody?.restitution = 0
            self.physicsBody?.categoryBitMask = ColliderType.player
            self.physicsBody?.collisionBitMask = ColliderType.ground
            self.physicsBody?.contactTestBitMask = ColliderType.player
            self.name = "Player"
        
            self.playerID = playerID
        
    }
    
    func movePlayer(with velocity: CGPoint){
        let moveX = (velocity.x * self.playerSpeed)
        self.position = CGPoint(x: self.position.x + moveX, y: self.position.y)
    }

    func jumpPlayer(){
        if self.grounded {
            self.grounded = false
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.jumpImpuse))
        }
    }
}
