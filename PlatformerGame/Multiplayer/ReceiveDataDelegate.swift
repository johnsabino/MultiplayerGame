//
//  ReceiveDataDelegate.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 20/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import SpriteKit

protocol ReceiveDataDelegate {
    func receiveData(from playerID: String, data : MessageData)
}
