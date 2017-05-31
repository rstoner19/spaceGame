//
//  THMachineNode.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/14/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class THMachineNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "machine_1.png")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func machineAtPostion() {
        self.texture = SKTexture(imageNamed: "machine_1.png")
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.zPosition = 8
        var frames = [SKTexture]()
        frames.append(SKTexture(imageNamed: "machine_1.png"))
        frames.append(SKTexture(imageNamed: "machine_2.png"))
        let machineAnimation = SKAction.animate(with: frames, timePerFrame: 0.25)
        let machineRepeat = SKAction.repeatForever(machineAnimation)
        self.run(machineRepeat)
        
    }
}
