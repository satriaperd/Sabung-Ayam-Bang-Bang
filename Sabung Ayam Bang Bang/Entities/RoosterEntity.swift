//
//  RoosterEntity.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import GameplayKit
import SpriteKit

class RoosterEntity: GKEntity {
    var stateMachine: GKStateMachine?
    var healthBarComponent: HealthBarComponent
    var hurtboxNode: SKNode?
    
    override init() {
        
        // Initializer Health Bar
        healthBarComponent = HealthBarComponent(maxHealth: 1000, initalHealth: 1000)
        super.init()
        
        stateMachine = StateMachine(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
