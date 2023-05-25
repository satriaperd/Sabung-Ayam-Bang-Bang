//
//  HitboxComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

class HitboxComponent: GKComponent, SKPhysicsContactDelegate {
    let hitboxNode: SKSpriteNode
    
    init(size: CGSize) {
        hitboxNode = SKSpriteNode(color: .green, size: size)
        hitboxNode.name = "Hitbox"
        
        super.init()
        
        hitboxNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        hitboxNode.physicsBody?.categoryBitMask = PhysicsCategory.Hitbox
        hitboxNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        hitboxNode.physicsBody?.contactTestBitMask = PhysicsCategory.Hurtbox
        hitboxNode.physicsBody?.isDynamic = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let hurtboxNode = contact.bodyB.node as? SKSpriteNode,
           let hurtboxComponent = hurtboxNode.entity?.component(ofType: HurtboxComponent.self),
        let healthBarComponent = hurtboxComponent.entity?.component(ofType: HealthBarComponent.self) {
            healthBarComponent.decreaseHealth(by: 10)
        }
    }
}


/*
class HitboxComponent: GKComponent {
    let hitboxNode: SKSpriteNode
    
    init(size: CGSize){
        hitboxNode = SKSpriteNode(color: .green, size: size)
        hitboxNode.name = "Hitbox"
        
        super.init()
        
        hitboxNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        hitboxNode.physicsBody?.categoryBitMask = PhysicsCategory.Hitbox
        hitboxNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        hitboxNode.physicsBody?.contactTestBitMask = PhysicsCategory.Hurtbox
        hitboxNode.physicsBody?.isDynamic = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
