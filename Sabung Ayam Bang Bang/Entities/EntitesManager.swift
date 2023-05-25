//
//  EntitesManager.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import GameplayKit
import SpriteKit

class EntityManager {
    var entities =  Set<GKEntity>()
    var nextEntitysID: Int = 0
    
    func createEntity() -> GKEntity {
        let entity = GKEntity()
        nextEntitysID += 1
        entities.insert(entity)
        
        return entity
    }
    
    func addComponent(_ component: GKComponent, to entity: GKEntity) {
        entity.addComponent(component)
    }
    
    func removeComponent(ofType componentClass: GKComponent.Type, from entity: GKEntity) {
        entity.removeComponent(ofType: componentClass)
    }

    func removeEntity(_ entity: GKEntity) {
        entities.remove(entity)
    }
    
    func update(deltaTime: TimeInterval) {
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
    }
    
    func getEntityForNode(_ node: SKNode) -> GKEntity? {
        for entity in entities {
            if let spriteNodeComponent = entity.component(ofType: SpriteComponents.self),
               spriteNodeComponent.node == node {
                return entity
            }
        }
        return nil
    }
}
