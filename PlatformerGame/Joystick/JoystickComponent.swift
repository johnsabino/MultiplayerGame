//
//  JoystickComponent.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 16/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

open class JoystickComponent : SKSpriteNode {
    private var kvoContext = UInt8(1)
    
    var borderWidth = CGFloat(8)
    var borderColor = UIColor.black
    var image: UIImage?
    
    var diameter: CGFloat {
        get {
            return size.width
        }
        set(newSize) {
            size = CGSize(width: newSize, height: newSize)
        }
    }
    var radius: CGFloat {
        get {
            return diameter * 0.5
        }
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    init(diameter: CGFloat, image: UIImage) {
        super.init(texture: nil, color: UIColor.black, size: CGSize(width: diameter, height: diameter))
        
        self.diameter = diameter
        self.image = image
        
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .normal, alpha: 0.4)
        
        let needImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        texture = SKTexture(image: needImage)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
