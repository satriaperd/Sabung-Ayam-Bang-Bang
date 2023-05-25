//
//  SpriteComponents.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import GameplayKit
import SpriteKit

class SpriteComponents: GKComponent {
    let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
