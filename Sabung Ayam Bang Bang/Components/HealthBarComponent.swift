//
//  HealthBarComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

class HealthBarComponent: GKComponent {
    let healthBarBackground: SKSpriteNode
    let activeHealthBarBackground: SKSpriteNode
    let activeHealthBar: SKSpriteNode
    
    var maxHealth: Float
    
    var currentHealth: Float {
        didSet {
            currentHealth = max(currentHealth, 0)
            updateHealthBar()
        }
    }
    
    init(maxHealth: Float, initalHealth: Float) {
        self.maxHealth = maxHealth
        self.currentHealth = initalHealth
        
        healthBarBackground = SKSpriteNode(color: .brown, size: CGSize(width: 280, height: 48))
        activeHealthBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: healthBarBackground.size.width - 8, height: healthBarBackground.size.height - 8))
        activeHealthBar = SKSpriteNode(color: .green, size: CGSize(width: activeHealthBarBackground.size.width, height: activeHealthBarBackground.size.height))
        
        super.init()
        
        healthBarBackground.zPosition = 1
        activeHealthBarBackground.zPosition = 2
        activeHealthBar.zPosition = 3
        
        // Add health bar to rooster
        if let bodyComponent = entity?.component(ofType: BodyComponent.self){
            bodyComponent.node?.addChild(healthBarBackground)
            bodyComponent.node?.addChild(activeHealthBarBackground)
            bodyComponent.node?.addChild(activeHealthBar)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decreaseHealth(by amount: Float) {
        currentHealth -= amount
        currentHealth = max(currentHealth, 0)
        updateHealthBar()
    }
    
    func updateHealthBar(){
        let healthPercentage = CGFloat(currentHealth) / CGFloat(maxHealth)
        let healthBarWidth = healthBarBackground.size.width * healthPercentage
        
        activeHealthBar.size = CGSize(width: healthBarWidth, height: activeHealthBar.size.height)
    }
}
