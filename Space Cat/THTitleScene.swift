//
//  THMyScene.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/9/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class THTitleScene: SKScene {
    
    private var backGround : SKSpriteNode?
    private var pressStart: SKAction?
    private var backGroundMusic: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
        let backgroundTexture = SKTexture(imageNamed: "splash_1")
        self.backGround = SKSpriteNode(texture: backgroundTexture, size: (self.scene?.size)!)
        backGround?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.backGround!)
        
        self.pressStart = SKAction.playSoundFileNamed("PressStart.caf", waitForCompletion: false)
        let url = Bundle.main.url(forResource: "StartScreen", withExtension: "mp3")

        do {
            self.backGroundMusic = try AVAudioPlayer.init(contentsOf: url!, fileTypeHint: nil)
            
        } catch {
            print("error getting background music")
        }
        if let _ = backGroundMusic {
            self.backGroundMusic!.numberOfLoops = -1
            self.backGroundMusic?.prepareToPlay()
            self.backGroundMusic?.play()
        }
        // Get label node from scene and store it for use later
        
        
        //Sprite Node
//        self.greenNode = SKSpriteNode.init(color: .green, size: CGSize(width: 10, height: 100))
//        self.greenNode?.position = CGPoint(x: 10, y: 10)
//        self.addChild(greenNode!)
//        self.redNode = SKSpriteNode.init(color: .red, size: CGSize(width: 100, height: 10))
//        self.redNode?.position = CGPoint(x: -100, y: 10)
//        self.redNode?.anchorPoint = CGPoint (x: 0, y: 0)
//        self.addChild(redNode!)
        
        
        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(pressStart!)
        if backGroundMusic != nil {
            self.backGroundMusic?.stop()
        }
        let gamePlayScene = GamePlayScene(size: self.frame.size)
        let transiction = SKTransition.doorway(withDuration: 1.0)
        self.view?.presentScene(gamePlayScene, transition: transiction)
    }
}

