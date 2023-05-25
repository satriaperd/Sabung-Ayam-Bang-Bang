//
//  PlayerStateMachine.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 24/05/23.
//

import GameplayKit
import SpriteKit

fileprivate let characterAnimationKey = "Sprite Animation"

class StateMachine: GKStateMachine {
    
    let roosterEntity: GKEntity
    
    init(_ entity: GKEntity) {
        
        self.roosterEntity = entity
        
        super.init(states: [
            IdleState(entity: entity),
            JumpingState(entity: entity),
            LandingState(entity: entity),
            AttackingState(entity: entity),
            WalkingState(entity: entity)
        ])
        
        enter(IdleState.self)
    }
}

class IdleState: GKState {
    let entity: GKEntity
    
    init(entity: GKEntity) {
        self.entity = entity
        
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        switch stateClass {
        case is WalkingState.Type, is AttackingState.Type, is JumpingState.Type : return false
        default: return true
        }
        
    }
}

class JumpingState: GKState {
    
    let entity: GKEntity
    var hasFinishedJumping: Bool = false
    let jumpPower: CGFloat = 20
    
    init(entity: GKEntity) {
        self.entity = entity
        
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if hasFinishedJumping && stateClass is LandingState.Type { return true }
        
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
}

class LandingState: GKState {
    let entity: GKEntity
    
    init(entity: GKEntity) {
        self.entity = entity
        
        super.init()
    }
}


class AttackingState: GKState {
    let entity: GKEntity
    
    init(entity: GKEntity) {
        self.entity = entity
        
        super.init()
    }
}

class WalkingState: GKState {
    let entity: GKEntity
    
    init(entity: GKEntity) {
        self.entity = entity
        
        super.init()
    }
}
