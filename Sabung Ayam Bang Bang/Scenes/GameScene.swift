//
//  GameScene.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Rooster: UInt32 = 0b1 // 1
    static let Border: UInt32 = 0b10 // 2
    static let Hitbox: UInt32 = 0b100 // 4
    static let Hurtbox: UInt32 = 0b1000 // 8
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    // Border Screen
    
    // Utilities
    let entityManager = EntityManager()
    
    // Joystick Controller
    var joystickBackground: JoystickBackground?
    var joystickKnob: JoystickKnob?
    
    // Attack Control
    var attackButton: SKSpriteNode?
    var isAttackPressed: Bool = false
    
    // Health Bar
    var healthBarComponent: HealthBarComponent?
    var hurtboxComponent: HurtboxComponent?
    
    // Rooster Entity
    var playerRooster: GKEntity!
    var aiRooster: GKEntity!
    var aiHealthbarComponent: HealthBarComponent!
    var playerIsFacingRight: Bool = true
    var bodyComponent: BodyComponent?
    
    // Jumping
    var isJumping: Bool = false
    let jumpThreshold: CGFloat = 40
    
    // Add Entities
    var entities: [GKEntity] = []
    
    // Update Time
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Screen Border
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = PhysicsCategory.Border
        borderBody.contactTestBitMask = PhysicsCategory.Rooster
        physicsBody = borderBody
        physicsWorld.contactDelegate = self

        // Attack Button
        attackButton = SKSpriteNode(imageNamed: "attack-button")
        attackButton?.position = CGPoint(x: (size.width / 2) - (attackButton?.size.width)!, y: -100)
        attackButton?.alpha = 0.4
        attackButton?.zPosition = 10
        addChild(attackButton!)
        
        // Add Rooster
        createRoosterEntity(isPlayer: true)
        createRoosterEntity(isPlayer: false)
        
        // Joystick Component
        joystickBackground = JoystickBackground()
        joystickKnob = JoystickKnob()
        
        // Summon Controller
        if let joystickBackground = joystickBackground, let joystickKnob = joystickKnob {
            
            joystickKnob.node.zPosition = 5
            joystickBackground.node.addChild(joystickKnob.node)
            
            joystickBackground.node.zPosition = 4
            addChild(joystickBackground.node)

            let joystickBackgroundSize = joystickBackground.node.frame.size
            
            joystickBackground.node.position = CGPoint(x: (-size.width / 2) + joystickBackgroundSize.width, y: (size.height / -2) + joystickBackgroundSize.height / 2 + 32 )
            joystickKnob.node.position = CGPoint.zero
            
        }
        
        // Physic World Gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
}

// MARK: Touches

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            
            // Joystick Touched
            if let joystickKnob = joystickKnob {
                let joystickBackground = joystickBackground?.node
                let location = touch.location(in: joystickBackground!)
                joystickKnob.isTracking = joystickKnob.node.contains(location)
            }

            // Attack Button Touched

            if let attackButton = attackButton {
                let position = touch.location(in: self)
                
                if attackButton.contains(position) {
                    if let mainHandComponent = playerRooster.component(ofType: MainHand.self) {
                        mainHandComponent.performAttack()
                    }
                }
            }

        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let joystickBackground = joystickBackground else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickKnob.isTracking { return }
        
        for touch in touches {
            let position = touch.location(in: joystickBackground.node)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)

            if joystickKnob.knobRadius > length {
                joystickKnob.node.position = position
            } else {
                joystickKnob.node.position = CGPoint(x: cos(angle) * joystickKnob.knobRadius, y: sin(angle) * joystickKnob.knobRadius)
            }
            
            // Check if Knob Position Available for Jumping
            if joystickKnob.node.position.y >= jumpThreshold {
                playerRooster.component(ofType: BodyComponent.self)?.applyJump()
                isJumping = true
            } else if joystickKnob.node.position.y < jumpThreshold {
                isJumping = false
            }

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let joystickBackground = joystickBackground else { return }
        
        for touch in touches {
            
            // Joystick Ended
            let sceneFrame = self.frame
            let xKnobCoordinate = touch.location(in: joystickBackground.node).x
            let xLimit = sceneFrame.width
            
            if xKnobCoordinate > -xLimit && xKnobCoordinate < xLimit {
                resetKnob()
                
                if let playerRooster = playerRooster, let bodyComponent = playerRooster.component(ofType: BodyComponent.self) {
                    
                    let joystickPosition = joystickKnob?.node.position
                    
                    if joystickPosition?.x ?? 0 < 0 {
                        bodyComponent.node?.xScale = -1
                        playerIsFacingRight = false
                    } else {
                        bodyComponent.node?.xScale = 1
                        playerIsFacingRight = true
                    }
                }
            }
            
            // Attack Ended

        }
    }
}



// MARK: Game Loop

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Moving the Rooster Player Image
        if let playerRooster = playerRooster {
            if let bodyComponent = playerRooster.component(ofType: BodyComponent.self),
               let joystickKnob = joystickKnob {
                let joystickPosition = joystickKnob.node.position

                let direction = CGVector(dx: joystickPosition.x, dy: 0)

                bodyComponent.move(direction: direction)
                
//                if let bodyNode = bodyComponent.node  {
//                    let bodySize = bodyNode.size
//                    let hurtboxRect = CGRect(x: bodyNode.position.x - (bodySize.width / 2), y: bodyNode.position.y - (bodySize.height), width: bodySize.width, height: bodySize.height)
//
//
//                    let bodySize = bodyNode.size
//                    let hurtboxSize = hurtboxComponent.node.size
//                    let hurtboxPosition = CGPoint(x: bodyNode.position.x, y: bodyNode.position.y - (bodySize.height / 2) - (hurtboxSize.height / 2))
//                    hurtboxComponent.node.position = hurtboxPosition
//                }
            }
            
            // Update hurtbox position

        }
        // MARK: Hurtbox Moving
        
        entityManager.update(deltaTime: deltaTime)
    }
}

// MARK: Function

// Reset Knob Position
extension GameScene {
    func resetKnob() {
        guard let joystickKnob = joystickKnob else { return }
        
        joystickKnob.isTracking = false
        
        let initialPosition = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPosition, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob.node.run(moveBack)
        joystickKnob.isTracking = false
    }
}

// Create Rooster Entity
extension GameScene {
    func createRoosterEntity(isPlayer: Bool) {
        let roosterEntity = entityManager.createEntity()
        
        // Rooster Component
        let bodyComponent = BodyComponent()
        let mainHandComponent = MainHand()
        let secondHandComponent = SecondHand()
        let healthBarComponent = HealthBarComponent(maxHealth: 1000, initalHealth: 1000)
        let hitboxComponent = HitboxComponent(size: CGSize(width: 24, height: 24))
        let hurtboxComponent = HurtboxComponent(size: CGSize(width: 40, height: 40), offset: CGPoint(x: 0, y: 0))
        
        // Register Rooster
        entityManager.addComponent(bodyComponent, to: roosterEntity)
        entityManager.addComponent(mainHandComponent, to: roosterEntity)
        entityManager.addComponent(secondHandComponent, to: roosterEntity)
        entityManager.addComponent(healthBarComponent, to: roosterEntity)
        entityManager.addComponent(hitboxComponent, to: roosterEntity)
//        entityManager.addComponent(hurtboxComponent, to: roosterEntity)
        
        
        // Create Rppster Node
        if let bodyComponent = roosterEntity.component(ofType: BodyComponent.self) {
            let bodyNode = bodyComponent.node
            self.bodyComponent = bodyComponent
            
            // Check X Position for Player and Ai
            let xPos: CGFloat = isPlayer ? -240 : 240
            
            // Setting Face Direction to the AI
            if !isPlayer {
                bodyNode?.xScale = -1
            }
            bodyNode?.position = CGPoint(x: xPos, y: 0)
            bodyNode?.zPosition = 1
            addChild(bodyNode!)
            
            if let frontHand = roosterEntity.component(ofType: MainHand.self) {
                let frontHandNode = frontHand.node
                frontHandNode.position = CGPoint(x: frontHandNode.position.x + 24, y: frontHandNode.position.y - 20)
                frontHandNode.zPosition = 1
                bodyNode?.addChild(frontHandNode)
            }
            if let backHand = roosterEntity.component(ofType: SecondHand.self) {
                let backHandNode = backHand.node
                backHandNode.position = CGPoint(x: backHandNode.position.x + 32, y: backHandNode.position.y - 10)
                backHandNode.zPosition = -1
                bodyNode?.addChild(backHandNode)
            }
            
//            if let hurtboxComponent = roosterEntity.component(ofType: HurtboxComponent.self) {
//                let bodyPosition = bodyComponent.node!.position
//                let bodySize = bodyComponent.node!.size
//                let hurtboxSize = hurtboxComponent.node.size
//                let hurtboxPosition = CGPoint(x: bodyPosition.x, y: bodyPosition.y - (bodySize.height / 2) - (hurtboxSize.height / 2))
//                hurtboxComponent.node.position = hurtboxPosition
//            }
            
        }
        
        if let healthBarComponent = roosterEntity.component(ofType: HealthBarComponent.self) {
            let healthBarBackground = healthBarComponent.healthBarBackground
            let activeHealthBarBackground = healthBarComponent.activeHealthBarBackground
            let activeHealthBar = healthBarComponent.activeHealthBar

            let healthPlayerPosition = -(healthBarBackground.size.width / 2) - (healthBarBackground.size.width / 4)
            let healthAiPosition = (healthBarBackground.size.width / 2) + (healthBarBackground.size.width / 4)

            // Adjust the position of the health bar nodes as per your requirement
            healthBarBackground.position = CGPoint(x: isPlayer ? healthPlayerPosition : healthAiPosition, y: (size.height / 2) - healthBarBackground.size.height)
            activeHealthBarBackground.position = CGPoint(x: 0, y: 0)
            activeHealthBar.position = CGPoint(x: 0, y: 0)

            addChild(healthBarBackground)
            healthBarBackground.addChild(activeHealthBarBackground)
            activeHealthBarBackground.addChild(activeHealthBar)
        }
        
        // Divine Rooster For Player and AI
        if isPlayer {
            playerRooster = roosterEntity
        } else {
            aiRooster = roosterEntity
        }
        
        // Insert Entity to Array of Entities
        entities.append(roosterEntity)
    }
}

