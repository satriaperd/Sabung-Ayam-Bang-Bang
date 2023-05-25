//
//  HurtboxComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

class HurtboxComponent: GKComponent {
    let node: SKSpriteNode
    var healthBarComponent: HealthBarComponent?
    
    init(size: CGSize, offset: CGPoint) {
        self.node = SKSpriteNode(color: .blue, size: size)
        super.init()
        
        // Add physics body to detect collisions
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.categoryBitMask = PhysicsCategory.Hurtbox
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Hitbox
        node.physicsBody?.isDynamic = false
        node.position = offset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decreaseHealth(by amount: Float) {
        healthBarComponent?.decreaseHealth(by: amount)
    }
}


//class HurtboxComponent: GKComponent {
//    let size: CGSize
//
//    init(size: CGSize) {
//        self.size = size
//        super.init()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
