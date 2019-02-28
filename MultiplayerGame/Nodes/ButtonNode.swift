//
//  ButtonNode.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

class ButtonNode: SKNode {
    typealias ActionBlock = (() -> Void)
    
    var actionBlock: ActionBlock?
    
    var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // intentionally blank
        }
    }
    
    private let labelNode: SKLabelNode
    
    init(_ text: String, size: CGSize, actionBlock: ActionBlock?) {
        
        let buttonFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        labelNode = SKLabelNode(fontNamed: buttonFont.fontName)
        labelNode.fontSize = buttonFont.pointSize
        labelNode.fontColor = .white
        labelNode.text = text
        labelNode.position = CGPoint(
            x: size.width / 2,
            y: size.height / 2 - labelNode.frame.height / 2
        )
        
        let shadowNode = SKLabelNode(fontNamed: buttonFont.fontName)
        shadowNode.fontSize = buttonFont.pointSize
        shadowNode.fontColor = .black
        shadowNode.text = text
        shadowNode.alpha = 0.5
        shadowNode.position = CGPoint(
            x: labelNode.position.x + 2,
            y: labelNode.position.y - 2
        )
        
        super.init()
        
        addChild(shadowNode)
        addChild(labelNode)
        
        self.actionBlock = actionBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isEnabled else {
            return
        }
        
        labelNode.run(SKAction.fadeAlpha(to: 0.8, duration: 0.2))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let block = actionBlock, isEnabled {
            block()
        }
        guard isEnabled else {
            return
        }
        
        labelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
    

}
