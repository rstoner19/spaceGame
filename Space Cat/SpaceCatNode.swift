//
//  SpaceCatNode.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/14/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class SpaceCatNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "spacecat_3.png")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var _tapAction: SKAction? = nil

    func spaceCatAtPostion(position: CGPoint) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.position = position
        self.zPosition = 9
    }
    
    var tapAction: SKAction {
        if _tapAction != nil {
            return _tapAction!
        }
        let textures = [SKTexture(imageNamed: "spacecat_2.png"), SKTexture(imageNamed: "spacecat_3.png")  ]
        
        _tapAction = SKAction.animate(with: textures, timePerFrame: 0.25)
        
        return _tapAction!
    }
    
    func performTap() {
        self.run(self.tapAction)
    }
    
}

