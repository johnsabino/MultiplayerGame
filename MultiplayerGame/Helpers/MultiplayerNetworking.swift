//
//  MultiplayerNetworking.swift
//  MultiplayerGame
//
//  Created by João Paulo de Oliveira Sabino on 14/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation
import GameKit

protocol ReceiveDataDelegate {
    func receiveData(position : [Double])
}
class MultiplayerNetworking : NSObject {
    
    static let networking = MultiplayerNetworking()
    
    var orderOfPlayers = [[String:Any]]()
    
    var playerEntered = [String:Any]()
    var player : [String: Any] = [:]
    
    var isPlayer1 : Bool = false
    
    override init() {
        
        let randomNumber = GKRandomSource.sharedRandom().nextUniform()
        
        player = ["playerID": GKLocalPlayer.local.playerID, "randomNumber": randomNumber]
        
        orderOfPlayers.append(player)
    }
    
    func sendData(position : [Double]){
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: position, requiringSecureCoding: false)
            
            try GameCenterHelper.helper.currentMatch?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print(error)
        }
        
    }
    
    
   
    func sendStartData(){
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: false)
            
            try GameCenterHelper.helper.currentMatch?.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("erro ao enviar start data: \(error.localizedDescription)" )
        }
    }
    
    func playersSorted(){
        orderOfPlayers.sort {
            if let randomA = $0["randomNumber"] as? Float, let randomB = $1["randomNumber"] as? Float {
                print("entrou no IF")
                return randomA > randomB
            }
            return false
        }
        
    
        if(orderOfPlayers[0]["playerID"] as? String == GKLocalPlayer.local.playerID){
            isPlayer1 = true
        }

    }
}
