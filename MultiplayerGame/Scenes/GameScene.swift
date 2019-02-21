//
//  GameScene.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var label2 : SKLabelNode!
    private var spinnyNode : SKShapeNode?

    private var viewWidth: CGFloat {
        return view?.frame.size.width ?? 0
    }
    
    private var viewHeight: CGFloat {
        return view?.frame.size.height ?? 0
    }
    
    var colorPlayer1 : SKColor = #colorLiteral(red: 1, green: 0, blue: 0.7614034414, alpha: 1)
    var colorPlayer2 : SKColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    
    override init() {
        super.init(size: .zero)
        
        scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {

        setupScene()
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 2),
                                              SKAction.fadeOut(withDuration: 1),
                                              SKAction.removeFromParent()]))
        }
        
        GameCenterHelper.helper.receiveDataDelegate = self
    }
    
    func setupScene(){
        guard viewWidth > 0 else {
            return
        }
        
        backgroundColor = SKColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos

            n.strokeColor = MultiplayerNetworking.networking.isPlayer1 ? colorPlayer1 : colorPlayer2
            self.addChild(n)
            
            let position : [Double] = [Double(pos.x), Double(pos.y)]
            MultiplayerNetworking.networking.sendData(position: position)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene : ReceiveDataDelegate {
    func receiveData(position: [Double]) {
        print("position in delegate: \(position)")
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = CGPoint(x: position[0], y: position[1])
            n.strokeColor = MultiplayerNetworking.networking.isPlayer1 ? colorPlayer2 : colorPlayer1
            self.addChild(n)
            
        }
    }
    
    
    
    
}
