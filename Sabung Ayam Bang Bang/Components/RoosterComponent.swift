//
//  RoosterComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import SpriteKit
import GameplayKit

class BodyComponent: GKComponent {
    let node: SKSpriteNode?
    let hurtbox: HurtboxComponent
    var healthbarComponent: HealthBarComponent?
    var stateMachine: GKStateMachine?
    
    override init() {
        let texture = SKTexture(imageNamed: "player/player1/player1")
        node = SKSpriteNode(texture: texture)
        node?.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        node?.physicsBody?.affectedByGravity = true
        node?.physicsBody?.isDynamic = true
        node?.physicsBody?.allowsRotation = false
        node?.physicsBody?.mass = 2
        
        let hurtbox = HurtboxComponent(size: texture.size(), offset: CGPoint(x: 0, y: 0))
        self.hurtbox = hurtbox
        
        super.init()
        hurtbox.healthBarComponent = healthbarComponent
        
    }
    
    // Jumping Function
    func move(direction: CGVector) {
        let speed: CGFloat = 6
        let velocity = CGVector(dx: direction.dx * speed, dy: node!.physicsBody!.velocity.dy)
        node?.physicsBody?.velocity = velocity
        
        if direction.dx < 0 {
            node?.xScale = -1
        } else if direction.dx > 0 {
            node?.xScale = 1
        }
    }
    
    // Update while it's done jump
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainHand: GKComponent {
    let node: SKSpriteNode
    let hitbox: HitboxComponent
    let hitboxNode: SKSpriteNode
    let initialPosition: CGPoint
    
    var oppenentHurtbox: HurtboxComponent?
    var isAttacking: Bool = false
    
    override init(){
        let texture = SKTexture(imageNamed: "player/player1/hand1")
        node = SKSpriteNode(texture: texture)
        
        hitbox = HitboxComponent(size: CGSize(width: 24, height: 24))
        hitboxNode = SKSpriteNode(color: .red, size: CGSize(width: 24, height: 24))
        initialPosition = .zero
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performAttack() {
        isAttacking = true
        let initialDamage = Int(arc4random_uniform(85))
        let damageCalculation = Float(initialDamage) + 10
        let damage = damageCalculation
        hitboxNode.position = .zero
        
        let hitboxPosition = CGPoint(x: node.position.x - 40, y: 0)
        hitboxNode.position = hitboxPosition
        
        node.addChild(hitboxNode)
        
        oppenentHurtbox?.decreaseHealth(by: damage)
        let attackAction = SKAction.sequence([
            SKAction.moveBy(x: hitboxPosition.x + 60, y: 0, duration: 0.1),
            SKAction.removeFromParent()
        ])
        
        hitboxNode.run(attackAction) { [weak self] in
            // Reset the hitbox back to the initial position
            self?.hitboxNode.position = .zero
        }
        
        isAttacking = false
    }
}

class SecondHand: GKComponent {
    let node: SKSpriteNode
    
    override init(){
        let texture = SKTexture(imageNamed: "player/player1/hand2")
        node = SKSpriteNode(texture: texture)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BodyComponent {
    func applyJump() {
        let jumpImpusle: CGFloat = 180
        node?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpImpusle))
    }
}
