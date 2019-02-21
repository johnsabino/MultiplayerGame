//
//  GameViewController.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var skView: SKView {
        return view as! SKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.presentScene(MenuScene())
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        
        GameCenterHelper.helper.authenticationViewController = self
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
