//
//  JoystickNode.swift
//  PlatformerGame
//
//  Created by João Paulo de Oliveira Sabino on 16/02/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

open class JoystickNode: SKNode {
    var trackingHandler: ((_ velocity: CGPoint) -> Void)?
    var beginHandler: (()-> Void)?
    var stopHandler:(()-> Void)?
    var substrate : JoystickComponent!
    var stick: JoystickComponent!
    var joystickIsEnabled = false
    private var tracking = false
    private(set) var direction = CGPoint.zero // can be read by other class, but not written
    
    var disabled: Bool {
        get {
            return !isUserInteractionEnabled
        }
        
        set(isDisabled) {
            isUserInteractionEnabled = !isDisabled
            
            if isDisabled {
                resetStick()
            }
        }
    }
    
    var diameter: CGFloat {
        get {
            return substrate.diameter
        }
        
        set(newDiameter) {
            //stick.diameter += newDiameter - diameter
            substrate.diameter = newDiameter
        }
    }
    
    var radius : CGFloat {
        get {
            return diameter * 0.5
        }
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    init(substrate: JoystickComponent, stick: JoystickComponent) {
        super.init()
        
        self.substrate = substrate
        substrate.zPosition = 0
        self.stick = stick
        stick.zPosition = 1
        
        addChild(substrate)
        addChild(stick)
        
        disabled = false
        
        let velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: .current, forMode: .common)
        
    }
    
    convenience init(diameters: (substrate: CGFloat, stick: CGFloat?), images: (substrate: UIImage, stick: UIImage)) {
        let stickDiameter = diameters.stick ?? diameters.substrate * 0.5
        let substrate = JoystickComponent(diameter: diameters.substrate, image: images.substrate)
        let stick = JoystickComponent(diameter: stickDiameter, image: images.stick)
        self.init(substrate: substrate, stick: stick)
    }
    
    convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage, stick: UIImage)) {
        self.init(diameters: (substrate: diameter, stick: nil), images: images)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func listen(){
        if tracking {
            trackingHandler?(direction)
        }
    }
    
    //MARK: - Overrides
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, stick == atPoint(touch.location(in: self)) {
            
            tracking = true
            joystickIsEnabled = true
            beginHandler?()
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let location = touch.location(in: self)
            
            guard tracking else {
                return
            }
            
            let maxDistance = substrate.radius - (stick.radius / 2)
            let realDistance : CGFloat = hypot(location.x, location.y) //hypot = cauculate the hypotenuse given 2 points
            
            
            let limitedLocation = CGPoint(x: (location.x / realDistance) * maxDistance, y: (location.y / realDistance) * maxDistance)
            
            let needPosition = realDistance <= maxDistance  ? location : limitedLocation
            
            stick.position = needPosition
            
            direction = needPosition
            
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
    }
    
    //MARK: - Private methods
    private func resetStick() {
        tracking = false
        let moveToBack = SKAction.move(to: CGPoint.zero, duration: TimeInterval(0.1))
        moveToBack.timingMode = .easeOut
        stick.run(moveToBack)
        direction = CGPoint.zero
        stopHandler?();
    }
}
