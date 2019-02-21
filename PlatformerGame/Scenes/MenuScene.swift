//
//  MenuScene.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 19/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var startButton : ButtonNode!
    var startSingleButton : ButtonNode!
    override func didMove(to view: SKView) {
        
        if let startBtn = childNode(withName: "StartButton") as? ButtonNode {
            self.startButton = startBtn
            startButton.isUserInteractionEnabled = true
            startButton.actionBlock = {
                GameCenterHelper.shared.presentMatchMaker()
            }
            
            startButton.isEnabled = GameCenterHelper.isAuthenticated
        }
        
        if let startSingleBtn = childNode(withName: "StartSingleButton") as? ButtonNode {
            self.startSingleButton = startSingleBtn
            startSingleButton.isUserInteractionEnabled = true
            startSingleButton.actionBlock = {
                if let gameScene = SKScene(fileNamed: "GameScene") as? GameScene {
                    view.presentScene(gameScene)
                }
                
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationChanged(_:)), name: .authenticationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGame(_:)), name: .presentGame, object: nil)
    }
    
    @objc private func authenticationChanged(_ notification: Notification) {
        startButton.isEnabled = notification.object as? Bool ?? false
    }
    
    @objc private func presentGame(_ notification: Notification){
        guard let match = notification.object as? GKMatch else {
            return
        }
        
        if let gameScene = SKScene(fileNamed: "GameScene") as? GameScene {
            // Set the scale mode to scale to fit the window
            gameScene.scaleMode = .aspectFill
            gameScene.currentMatch = match

                        
            // Present the scene
            self.view?.presentScene(gameScene)
        }
        
        
        
        GameCenterHelper.shared.currentMatch = match
    }
}


