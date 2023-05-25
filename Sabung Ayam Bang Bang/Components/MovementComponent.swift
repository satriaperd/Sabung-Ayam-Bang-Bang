//
//  MovementComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

class MovementSystem: GKComponentSystem<GKComponent> {
    
    override func update(deltaTime seconds: TimeInterval) {
        for component in components {
            if let joystickKnob = component.entity?.component(ofType: JoystickKnob.self),
               let bodyComponent = component.entity?.component(ofType: BodyComponent.self) {
                
                let joystickPosition = joystickKnob.node.position
                
                let movementSpeed: CGFloat = 2
                let movementVector = CGVector(dx: joystickPosition.x * movementSpeed, dy: 0)
                
                bodyComponent.node?.position.x += movementVector.dx * CGFloat(seconds)
                
            }
        }
    }
}


