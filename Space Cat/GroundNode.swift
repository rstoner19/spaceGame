//
//  GroundNode.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/20/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GroundNode: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size:size)
        self.position = CGPoint(x: size.width/2 , y: size.height/2)
        self.setupPhysicsBody()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Constants.CollisionCategory.Ground.rawValue
        self.physicsBody?.collisionBitMask = Constants.CollisionCategory.Debris.rawValue
        self.physicsBody?.contactTestBitMask = Constants.CollisionCategory.Enemy.rawValue
        
    }


}
