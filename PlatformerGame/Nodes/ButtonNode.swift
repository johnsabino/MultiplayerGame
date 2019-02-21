//
//  ButtonNode.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 19/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

class ButtonNode: SKNode {
    
    var actionBlock : (() -> Void)?

    var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1 : 0.4
        }
    }
    
//    init(actionBlock: (() -> Void)?) {
//        super.init()
//        self.actionBlock = actionBlock
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isEnabled else {
            return
        }
        
        self.run(SKAction.fadeAlpha(to: 0.8, duration: 0.2))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let block = actionBlock, isEnabled {
            block()
        }
        guard isEnabled else {
            return
        }
        
        self.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
}
