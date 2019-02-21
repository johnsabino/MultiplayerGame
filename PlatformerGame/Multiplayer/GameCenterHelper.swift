//
//  GameCenterHelper.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 19/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

class GameCenterHelper: NSObject {
    static let shared = GameCenterHelper()
    
    var authenticationViewController: UIViewController?
    var currentMatch: GKMatch?
    var currentMatchmakerVC: GKMatchmakerViewController?
    
    var receiveDataDelegate: ReceiveDataDelegate?
    static var isAuthenticated : Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    override init(){
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = { authenticationVC, error in
            
            NotificationCenter.default.post(name: .authenticationChanged , object: GKLocalPlayer.local.isAuthenticated)
            
            if GKLocalPlayer.local.isAuthenticated {
                print("Authenticated to Game Center!")
                
            }
            else if let vc = authenticationVC {
                self.authenticationViewController?.present(vc,animated: true)
            }
            else{
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }
            
        }
    }
    
    func presentMatchMaker(){
        print(GKLocalPlayer.local.isAuthenticated)
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let request = GKMatchRequest()
        
        request.minPlayers = 2
        request.maxPlayers = 2
        
        request.inviteMessage = "Would you like to play?"
        
        if let vc = GKMatchmakerViewController(matchRequest: request) {
            vc.matchmakerDelegate = self
            currentMatchmakerVC = vc
            authenticationViewController?.present(vc, animated: true)
        }
    }
}

extension GameCenterHelper : GKMatchmakerViewControllerDelegate {
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker did fail with error: \(error.localizedDescription).")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        self.currentMatch = match
        match.delegate = self
        NotificationCenter.default.post(name: .presentGame, object: match)
        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
            
            
        }
    }
}

extension GameCenterHelper : GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let d = MessageData.unarchive(data)
        receiveDataDelegate?.receiveData(from: player.playerID, data: d)
            
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if (self.currentMatch != match) {
            return
        }
        
        switch state {
        case GKPlayerConnectionState.connected:
            print("Player Conected!")
            
        case GKPlayerConnectionState.disconnected:
            print("Player Disconected!")
        default:
            print(state)
        }
    }
}

