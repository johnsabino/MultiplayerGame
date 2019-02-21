//
//  GameScene.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 16/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

protocol DidStartMatchDelegate {
    func allocPlayers(with playerID: String)
}

class GameScene: SKScene, ReceiveDataDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var player: CharacterNode?
    private var othersPlayers : [String: CharacterNode] = [:]
    public var currentMatch : GKMatch?
    var joystick : JoystickNode!
    
    var leftControlTouch = UITouch()
    var rightControlTouch = UITouch()
    
    let physicsDelegate = PhysicsDetection()
    
    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        setupGround()
        
        if let player = childNode(withName: "Player") as? CharacterNode {
            player.setupPlayer(playerID: GKLocalPlayer.local.playerID)
            self.player = player
            
        }
        
        setupJoystick()
        
        self.physicsWorld.contactDelegate = physicsDelegate
        //physicsDelegate.player = player
        
        if let match = currentMatch {
            print("match players count:", match.players.count)
            match.players.forEach {
                allocPlayers(with: $0.playerID)
                
            }
        }
        
        GameCenterHelper.shared.receiveDataDelegate = self
    }
    
    func setupJoystick(){
        guard let substrateImg = UIImage(named: "ControlPad") else {return}
        guard let stickImg = UIImage(named: "ControlPad") else {return}
        joystick = JoystickNode(diameter: 100, images: (substrate: substrateImg, stick: stickImg))
        joystick.position = CGPoint(x: joystick.radius + 50, y: joystick.radius + 50)
        joystick.isHidden = true
        addChild(joystick)
        
        joystick.trackingHandler = { velocity in
            if let p = self.player {
                
                p.movePlayer(with: velocity)
                let data = MessageData(isJumping: false, position: p.position)
                Networking.shared.sendData(data: data)
                
            }
        }
    }
    
    func setupGround(){
        if let ground = childNode(withName: "Ground") as? SKSpriteNode {
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.allowsRotation = false
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.restitution = 0
            ground.physicsBody?.categoryBitMask = ColliderType.ground
            ground.physicsBody?.contactTestBitMask = ColliderType.player
            ground.name = "Ground"
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            
            if location.x < size.width/2 {
                leftControlTouch = touch
                joystick.position = location
                joystick.isHidden = false
                joystick.touchesBegan([touch], with: event)
            }else if let p = self.player{
                p.jumpPlayer()
                rightControlTouch = touch
                let data = MessageData(isJumping: true, position: p.position)
                Networking.shared.sendData(data: data)
                
            }
            
        }
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if location.x < size.width/2 {
                joystick.touchesMoved([touch], with: event)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //if touch.location(in: self).x < size.width/2 {
            if touch == leftControlTouch {
                joystick.isHidden = true
                joystick.touchesEnded([touch], with: event)
            }
            
           // }
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch == leftControlTouch {
                joystick.isHidden = true
                joystick.touchesCancelled([touch], with: event)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    

    func allocPlayers(with playerID: String) {
        print(playerID)
        let otherPlayer = CharacterNode(color: UIColor(red: 1, green: 170/255, blue: 20/255, alpha: 1), size: CGSize(width: 50, height: 50))
        otherPlayer.setupPlayer(playerID: playerID)
        otherPlayer.position = CGPoint(x: 300, y: 120)
        othersPlayers[playerID] = otherPlayer
        addChild(otherPlayer)
    }
    
    func receiveData(from playerID: String, data: MessageData) {
  
        guard let otherPlayer = othersPlayers[playerID] else {return}
        print("is other player grounded: ", otherPlayer.grounded)
        if data.isJumping && otherPlayer.grounded{
            otherPlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
            otherPlayer.grounded = false
        }else if !data.isJumping && otherPlayer.grounded{
            othersPlayers[playerID]?.position = data.position
        }
        
    }
}
