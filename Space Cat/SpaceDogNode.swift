//
//  SpaceDogNode.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/19/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum SpaceDogType {
    case TypeA
    case TypeB
}

class SpaceDogNode: SKSpriteNode {
    
    let spaceDog: SpaceDogType
    
    init(spaceDog: SpaceDogType) {
        self.spaceDog = spaceDog
        let texture: SKTexture
        if spaceDog == SpaceDogType.TypeA {
            texture = SKTexture(imageNamed: "spacedog_A_1")
        } else {
            texture = SKTexture(imageNamed: "spacedog_B_1")
        }
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.setupPhysicsBody()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animateSpaceDog() {
        let textures: [SKTexture]
        if self.spaceDog == .TypeA {
            textures = [SKTexture(imageNamed: "spacedog_A_1"), SKTexture(imageNamed: "spacedog_A_2") ,SKTexture(imageNamed: "spacedog_A_3")]
        } else {
            textures = [SKTexture(imageNamed: "spacedog_B_1"), SKTexture(imageNamed: "spacedog_B_2"), SKTexture(imageNamed: "spacedog_B_3"), SKTexture(imageNamed: "spacedog_B_4")]
        }
        let scale: CGFloat = CGFloat(Constants.randomWithMin(max: 100, min: 50)) / 100
        self.xScale = scale
        self.yScale = scale
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
        let repeatAnimation = SKAction.repeatForever(animation)
        self.run(repeatAnimation)
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.velocity = CGVector(dx: 0, dy: -50)
        self.physicsBody?.categoryBitMask = Constants.CollisionCategory.Enemy.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = Constants.CollisionCategory.Projectile.rawValue | Constants.CollisionCategory.Ground.rawValue
    }

}
