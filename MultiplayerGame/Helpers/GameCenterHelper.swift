//
//  GameCenterHelper.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

class GameCenterHelper: NSObject {
    static var helper = GameCenterHelper()
    
    var authenticationViewController: UIViewController?
    
    var currentMatch: GKMatch?
    var currentMatchmakerVC: GKMatchmakerViewController?
    static var isAuthenticated : Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    
    var receiveDataDelegate : ReceiveDataDelegate?
    
    override init() {
        super.init()
        print("init no game center")
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            //6 - call notification center when authentication changed
            NotificationCenter.default.post(name: .authenticationChanged , object: GKLocalPlayer.local.isAuthenticated)
            
            if GKLocalPlayer.local.isAuthenticated {
                print("Authenticated to Game Center!")
               
                GKLocalPlayer.local.register(self)
            }
            else if let vc = gcAuthVC {
                self.authenticationViewController?.present(vc,animated: true)
            }
            else{
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }
            
        }
    }
    
    func presentMatchMaker(){
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
    
    func lookupPlayers(){
        if let match = currentMatch {
            match.players.forEach { (player) in
                print(player.displayName)
            }
            
            print("PLAYER LOCAL: \(GKLocalPlayer.local.displayName)")
        }
        
    }
}

extension Notification.Name {
    //notifies the menu scene to present an online game
    static let presentGame = Notification.Name(rawValue: "presentGame")
    //notifies the app of any authentication state changed
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}


extension GameCenterHelper : GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print("Match found!")
        self.currentMatch = match
        
        NotificationCenter.default.post(name: .presentGame, object: match)
        match.delegate = self

        MultiplayerNetworking.networking.sendStartData()
        self.lookupPlayers()
        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
        }
    }
    
}
extension GameCenterHelper: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print(match.players.count)
        do {
            if let position = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Double] {
                receiveDataDelegate?.receiveData(position: position)
            }
        } catch {
            print("error while receiving data111: \(error.localizedDescription)")
        }
        
        do {
            
            if let start = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                MultiplayerNetworking.networking.orderOfPlayers.append(start)
                
                print("sorteei os jogadores")
                MultiplayerNetworking.networking.playersSorted()
                
            }
        } catch {
            print("error while receiving data2222: \(error.localizedDescription)")
        }
        
    
        
        
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if (self.currentMatch != match) {
            return
        }
        
        switch state {
        case GKPlayerConnectionState.connected:
            print("Player Conected!")
            self.lookupPlayers()
        case GKPlayerConnectionState.disconnected:
            print("Player Disconected!")
        default:
            print(state)
        }
    }
}

extension GameCenterHelper : GKLocalPlayerListener {
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        print("ACEITOU INVITE")
    }
    
}
