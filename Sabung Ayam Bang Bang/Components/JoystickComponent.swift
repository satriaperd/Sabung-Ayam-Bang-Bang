//
//  JoystickComponent.swift
//  Sabung Ayam Bang Bang
//
//  Created by Satria Perdana on 23/05/23.
//

import GameplayKit
import SpriteKit

class JoystickBackground: GKComponent {
    let node: SKSpriteNode
    
    override init(){
        let texture = SKTexture(imageNamed: "arrow")
        node = SKSpriteNode(texture: texture)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JoystickKnob: GKComponent {
    let node: SKSpriteNode
    var isTracking: Bool = false
    let knobRadius: CGFloat = 48.0
    
    override init(){
        let texture = SKTexture(imageNamed: "knob")
        node = SKSpriteNode(texture: texture)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
