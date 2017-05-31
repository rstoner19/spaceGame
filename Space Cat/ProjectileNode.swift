//
//  ProjectileNode.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/15/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ProjectileNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "projectile_1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAnimation() {
        let textures = [SKTexture(imageNamed: "projectile_1"), SKTexture(imageNamed: "projectile_2") ,SKTexture(imageNamed: "projectile_3")]
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animation)
        self.run(repeatAction)
    }
    
    func projectileAtPostion(position: CGPoint) {
        
        self.texture = SKTexture(imageNamed: "projectile_1")
        self.name = "Projectile"
        self.position = position
        setupAnimation()
        setupPhysicsBody()
    }
    
    func moveTowardsPosition(postion: CGPoint) {
        // slope = (y3 - y1) / (x3 - x1)
        let slope = (postion.y - self.position.y) / (postion.x - self.position.x)
        // y2 = slope (x2 - x1) + y1
        
        let offScreenX: CGFloat
        if postion.x <= self.position.x {
            offScreenX = -10
        } else {
            offScreenX = (self.parent?.frame.size.width)! + 10
        }
        let offScreenY = slope * (offScreenX - self.position.x) + self.position.y
        let pointOffscreen = CGPoint(x: offScreenX, y: offScreenY)
        let distance = sqrtf(powf((Float(offScreenY) - Float(self.position.y)), 2) + powf((Float(offScreenX) - Float(self.position.x)), 2))
        let time = distance / Constants.ProjectileSpeed

        let moveProjectile = SKAction.move(to: pointOffscreen, duration: TimeInterval(time))
        let fadeProjectile = [SKAction.wait(forDuration: TimeInterval(time * 0.75)), SKAction.fadeOut(withDuration: TimeInterval(time * 0.25))]
        self.run(SKAction.sequence(fadeProjectile))
        self.run(moveProjectile, completion: { () in
                self.removeFromParent()
            })
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.CollisionCategory.Projectile.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = Constants.CollisionCategory.Enemy.rawValue
    }
    
    

}
