//
//  MenuScene.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    private var startButton: ButtonNode!
    
    override init() {
        super.init(size: .zero)
        
        scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScene(){
        
        backgroundColor = SKColor(red: 38/255, green: 192/255, blue: 87/255, alpha: 1)
        
        let sceneMargin: CGFloat = 40
        let viewWidth = view?.frame.size.width ?? 0
        let buttonWidth: CGFloat = viewWidth - (sceneMargin * 2)
        let buttonSize = CGSize(width: buttonWidth, height: buttonWidth * 3 / 11)
        
        startButton = ButtonNode("Start Game", size: buttonSize, actionBlock: {
            
            GameCenterHelper.helper.presentMatchMaker()
        })
        
        startButton.isEnabled = GameCenterHelper.isAuthenticated
        
        startButton.position = CGPoint(x: sceneMargin, y: 200)
        addChild(startButton)
        
    }
    
    override func didMove(to view: SKView) {
        setupScene()
        
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
        
        loadAndDisplay(match: match)
        GameCenterHelper.helper.currentMatch = match
    }
    
    private func loadAndDisplay(match: GKMatch){
        
        self.view?.presentScene(GameScene())
        
    }
}
