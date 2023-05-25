//
//  AttackComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

class AttackButton: GKComponent {
    let attackButton: SKSpriteNode
    var isAttacking: Bool = false
    var hitboxComponent: HitboxComponent?
    
    init(attackButton: SKSpriteNode, isAttacking: Bool){
        self.attackButton = attackButton
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AttackComponent: GKComponent {

    func createHitbox() {
        let hitboxSize = CGSize(width: 24, height: 24)
        let hitbox = SKSpriteNode(color: .red, size: hitboxSize)
        hitbox.name = "hitbox"
        
        if let bodyComponent = entity?.component(ofType: BodyComponent.self) {
            hitbox.position = CGPoint(x: bodyComponent.node!.position.x, y: bodyComponent.node!.position.y)
            bodyComponent.node?.addChild(hitbox)
        }
    }
}
