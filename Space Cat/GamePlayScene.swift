//
//  GamePlayScene.swift
//  Space Cat
//
//  Created by Rick Stoner on 12/13/16.
//  Copyright © 2016 Rick Stoner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    private var backGround : SKSpriteNode?
    private var spaceCat: SpaceCatNode?
    private var machine: THMachineNode?
    private var lastUpdateTimeInterval: TimeInterval = 0
    private var timeSinceEnemyAdded: TimeInterval = 0
    private var totalGametime: TimeInterval = 0
    private var minSpeed: Int = Constants.SpaceDogMinSpeed
    private var addEnemyTimeInterval: TimeInterval = 1.5
    private var initialGameTime: TimeInterval?
    private var damageSFX: SKAction?
    private var explodeSFX: SKAction?
    private var laserSFX: SKAction?
    private var backGroundMusic: AVAudioPlayer?
    private var gameOverMusic: AVAudioPlayer?
    private var lastLifebar: SKSpriteNode?
    private var scoreLabel: SKLabelNode?
    private var score: Int?
    private var lives: Int?
    private var hud: SKNode?
    private var restart: Bool?
    
    override func didMove(to view: SKView) {
        
        let backgroundTexture = SKTexture(imageNamed: "background_1")
        self.backGround = SKSpriteNode(texture: backgroundTexture, size: (self.scene?.size)!)
        backGround?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.backGround!)
        self.timeSinceEnemyAdded = 0
        self.lastUpdateTimeInterval = 0
        self.restart = false
        
        machine = THMachineNode()
        machine?.machineAtPostion()
        machine?.name = "Machine"
        machine?.position = CGPoint(x: self.frame.midX, y: size.height * 0.05)
        self.addChild(machine!)
        
        spaceCat = SpaceCatNode()
        spaceCat?.spaceCatAtPostion(position: CGPoint(x: self.frame.midX, y: size.height * 0.05))
        self.addChild(spaceCat!)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
        
        let groundNode = GroundNode(size: CGSize(width: self.frame.size.width, height: 22))
        self.addChild(groundNode)
        setupSounds()
        
        self.hud = SKNode.init()
        hud?.position = CGPoint(x: 0, y: self.frame.size.height - 20)
        hud?.zPosition = 10000
        
        let catHead = SKSpriteNode.init(imageNamed: "HUD_cat_1")
        catHead.position = CGPoint(x: 20, y: -10)
        hud?.addChild(catHead)
        
        self.lives = Constants.lives
        for life in 0..<lives!{
            let lifeBar = SKSpriteNode.init(imageNamed: "HUD_life_1")
            lifeBar.name = "Life\(life + 1)"
            hud?.addChild(lifeBar)
            
            if let lastLife = self.lastLifebar {
                lifeBar.position = CGPoint(x: lastLife.position.x + 10, y: catHead.position.y)
            } else {
                lifeBar.position = CGPoint(x: catHead.position.x + 30, y: catHead.position.y)
            }
            lastLifebar = lifeBar
        }
        self.scoreLabel = SKLabelNode.init(fontNamed: Constants.fontText)
        self.scoreLabel?.text = "0"
        self.scoreLabel?.fontSize = 24
        self.scoreLabel?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.scoreLabel?.position = CGPoint(x: (self.frame.size.width) - 20, y: -10)
        hud?.addChild(scoreLabel!)
        self.score = 0
        self.addChild(hud!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.restart == false {
            for touch in touches {
                let position = touch.location(in: self)
                self.shootProjectileTowardsPosition(postion: position)
            }
        } else {
            restartNewGame()
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if initialGameTime == nil {
            initialGameTime = currentTime
        }
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval
        self.totalGametime = currentTime - initialGameTime!
        if self.timeSinceEnemyAdded > self.addEnemyTimeInterval && self.restart == false {
            addSpaceDog()
            self.timeSinceEnemyAdded = 0
        }
        self.lastUpdateTimeInterval = currentTime
        switch totalGametime {
        case let x where x > 180:
            self.addEnemyTimeInterval = 0.5
            self.minSpeed = -220
            break
        case let x where x > 150:
            self.addEnemyTimeInterval = 0.5
            self.minSpeed = -190
            break
        case let x where x > 120:
            self.addEnemyTimeInterval = 0.6
            self.minSpeed = -180
            break
        case let x where x > 90:
            self.addEnemyTimeInterval = 0.6
            self.minSpeed = -160
            break
        case let x where x > 60:
            self.addEnemyTimeInterval = 0.7
            self.minSpeed = -150
            break
        case let x where x > 45:
            self.addEnemyTimeInterval = 0.8
            self.minSpeed = -125
            break
        case let x where x > 30:
            self.addEnemyTimeInterval = 1.0
            self.minSpeed = -125
            break
        case let x where x > 15:
            self.addEnemyTimeInterval = 1.25
            self.minSpeed = -110
            break
        default:
            self.addEnemyTimeInterval = 1.5
            self.minSpeed = -100
            break
        }
    }
    
    func setupSounds() {
        self.damageSFX = SKAction.init()
        damageSFX = SKAction.playSoundFileNamed("Damage.caf", waitForCompletion: true)
        self.explodeSFX = SKAction.playSoundFileNamed("Explode.caf", waitForCompletion: false)
        self.laserSFX = SKAction.playSoundFileNamed("Laser.caf", waitForCompletion: false)
        let url = Bundle.main.url(forResource: "Gameplay", withExtension: "mp3")
        let gameOverURL = Bundle.main.url(forResource: "GameOver", withExtension: "mp3")
        
        do {
            self.backGroundMusic = try AVAudioPlayer.init(contentsOf: url!, fileTypeHint: nil)
            self.gameOverMusic = try AVAudioPlayer.init(contentsOf: gameOverURL!, fileTypeHint: nil)
        } catch {
            print("error getting background music")
        }
        if let _ = backGroundMusic {
            self.backGroundMusic!.numberOfLoops = -1
            self.backGroundMusic?.prepareToPlay()
            self.backGroundMusic?.play()
        }
        if let _ = gameOverMusic {
            self.gameOverMusic!.numberOfLoops = 1
            self.gameOverMusic?.prepareToPlay()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody, secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == Constants.CollisionCategory.Enemy.rawValue && secondBody.categoryBitMask == Constants.CollisionCategory.Projectile.rawValue {
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            self.addPoints()
            self.run(explodeSFX!)
        } else if firstBody.categoryBitMask == Constants.CollisionCategory.Enemy.rawValue && secondBody.categoryBitMask == Constants.CollisionCategory.Ground.rawValue {
            firstBody.node?.removeFromParent()
            self.loseLife()
            self.run(damageSFX!)
        }
        createDebrisAtPostion(impactPostion: contact.contactPoint)
    }
    
    func shootProjectileTowardsPosition(postion: CGPoint) {
        spaceCat?.performTap()
        let projectile = ProjectileNode()
        let startPosition = CGPoint(x: self.frame.midX, y: size.height * 0.05 + (machine?.frame.size.height)! - 15)
        projectile.projectileAtPostion(position: startPosition)
        self.addChild(projectile)
        projectile.moveTowardsPosition(postion: postion)
        self.run(self.laserSFX!)
    }
    
    func addSpaceDog() {
        let randomValue = randomWithMin(max: 2, min: 0)
        var spaceDogType: SpaceDogType
        switch randomValue {
        case 0:
            spaceDogType = .TypeA
        default:
            spaceDogType = .TypeB
        }
    
        let spaceDog = SpaceDogNode(spaceDog: spaceDogType)
        spaceDog.animateSpaceDog()
        spaceDog.physicsBody?.velocity = CGVector(dx: 0, dy: randomWithMin(max: Constants.SpaceDogMaxSpeed, min: self.minSpeed))

        let xPosition = randomWithMin(max: Int(self.frame.size.width) - 10 - Int(spaceDog.size.width), min: Int(spaceDog.size.width) + 10)
        spaceDog.position = CGPoint(x: CGFloat(xPosition), y: self.frame.size.height + spaceDog.size.height)
        self.addChild(spaceDog)
        
    }
    
    func createDebrisAtPostion(impactPostion: CGPoint) {
        let numberOfPieces = randomWithMin(max: 20, min: 5)
        for _ in 0..<numberOfPieces {
            let randomPiece = randomWithMin(max: 4, min: 1)
            let imageName = "debri_" + String(randomPiece)
            let texture = SKTexture(imageNamed: imageName)
            let debris = SKSpriteNode.init(texture: texture)
            debris.position = impactPostion
            self.addChild(debris)
            
            debris.physicsBody = SKPhysicsBody.init(rectangleOf: debris.frame.size)
            debris.physicsBody?.categoryBitMask = Constants.CollisionCategory.Debris.rawValue
            debris.physicsBody?.contactTestBitMask = 0
            debris.physicsBody?.velocity = CGVector(dx: randomWithMin(max: 150, min: -150), dy: randomWithMin(max: 350, min: 150))
            self.run(SKAction.wait(forDuration: 2.0), completion: {
                debris.removeFromParent()
            })
        }
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = impactPostion
        self.addChild(explosion!)
        self.run(SKAction.wait(forDuration: 2.0)) { 
            explosion?.removeFromParent()
        }
    }
    
    func randomWithMin(max: Int, min: Int) -> (Int) {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func addPoints() {
        self.score! += Constants.pointPerHit
        self.scoreLabel?.text = String(self.score!)
    }
    
    func loseLife() {
        if self.lives! > 0 {
            let lifeNodeName = "Life\(self.lives!)"
            let lifeToRemove = self.hud?.childNode(withName: lifeNodeName)
            self.lives = self.lives! - 1
            lifeToRemove?.removeFromParent()
        } else if self.restart != true {
            gameOver()
        }
    }
    
    func gameOver() {
        let fire = SKEmitterNode(fileNamed: "GameOverFire")
        fire?.position = CGPoint(x: self.frame.midX, y: 0)
        self.addChild(fire!)
        self.backGroundMusic?.stop()
        self.gameOverMusic?.play()
        let gameOverLabel = SKLabelNode.init(fontNamed: Constants.fontText)
        gameOverLabel.text = "Game Over"
        gameOverLabel.name = "GameOver"
        gameOverLabel.fontSize = 48
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(gameOverLabel)
        performAnimation(node: gameOverLabel)
        self.restart = true
    }
    
    func restartNewGame() {
        for node in self.children {
            node.removeFromParent()
        }
        self.scene?.removeFromParent()
        let scene = GamePlayScene(size: self.frame.size)
        self.view?.presentScene(scene)
    }
    
    func performAnimation(node: SKLabelNode) {
        node.xScale = 0
        node.yScale = 0
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.75)
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.25)
        let runAction = SKAction.run({
            let touchToRestart = SKLabelNode(fontNamed: Constants.fontText)
            touchToRestart.fontSize = 12
            touchToRestart.text = "Touch to Restart"
            touchToRestart.position = CGPoint(x: self.frame.midX, y: node.position.y - 40)
            self.addChild(touchToRestart)
        })
        let scale = SKAction.sequence([scaleUp, scaleDown, runAction])
        node.run(scale)
    }
}


    
