//
//  GameScene.swift
//  UberJump
//
//  Created by Alexander Frolov on 04/02/15.
//  Copyright (c) 2015 Alexander Frolov. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    let backgroundNode = SKNode()
    let midgroundNode = SKNode()
    let foregroundNode = SKNode()
    let hudNode = SKNode()
    
    let player = SKNode()
    let tapToStart = SKSpriteNode(imageNamed: "TapToStart")
    
    let scaleFactor: CGFloat = 0.0
    
    let endLevelY = 0
    var maxPlayerY = 80
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    var lblScore: SKLabelNode!
    var lblStars: SKLabelNode!
    
    var gameOver = false
    
    var audioPlayer: AVAudioPlayer?
    
    func RandomThemeMusic(Mp3Name : String)
    {
        audioPlayer?.stop()
        
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource(Mp3Name,
                ofType: "mp3")!)
        
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        if let err = error {
            println("audioPlayer error \(err.localizedDescription)")
        } else {
            
            audioPlayer?.prepareToPlay()
        }
        audioPlayer?.play()
        audioPlayer?.numberOfLoops = 100
        
    }

    

    override init(size: CGSize) {
         
        super.init(size: size)
        
        
        backgroundColor = SKColor.whiteColor()
        scaleFactor = size.width / 320.0
        
        GameState.sharedInstance.score = 0
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        
        midgroundNode = createMidgroundNode()
        addChild(midgroundNode)
        
        addChild(foregroundNode)

        addChild(hudNode)
    
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        endLevelY = levelData["EndY"]!.integerValue
        
        let platforms = levelData["Platforms"] as NSDictionary
        let platformPatterns = platforms["Patterns"] as NSDictionary
        let platformPositions = platforms["Positions"] as [NSDictionary]
        
        for platformPosition in platformPositions {
            let patternX = platformPosition["x"]?.floatValue
            let patternY = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as NSString
            
            let platformPattern = platformPatterns[pattern] as [NSDictionary]
            for platformPoint in platformPattern {
                let x = platformPoint["x"]?.floatValue
                let y = platformPoint["y"]?.floatValue
                let type = PlatformType(rawValue: platformPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = createPlatformAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(platformNode)
            }
        }
        
        let stars = levelData["Stars"] as NSDictionary
        let starPatterns = stars["Patterns"] as NSDictionary
        let starPositions = stars["Positions"] as [NSDictionary]
        
        for starPosition in starPositions {
            let patternX = starPosition["x"]?.floatValue
            let patternY = starPosition["y"]?.floatValue
            let pattern = starPosition["pattern"] as NSString
            
            let starPattern = starPatterns[pattern] as [NSDictionary]
            for starPoint in starPattern {
                let x = starPoint["x"]?.floatValue
                let y = starPoint["y"]?.floatValue
                let type = StarType(rawValue: starPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let starNode = createStarAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(starNode)
            }
        }
        
        player = createPlayer()
        foregroundNode.addChild(player)
        
        tapToStart.position = CGPoint(x: size.width / 2, y: 180)
        hudNode.addChild(tapToStart)
        
        let star = SKSpriteNode(imageNamed: "Star")
        star.position = CGPoint(x: 25, y: size.height - 70)
        hudNode.addChild(star)
        
        lblStars = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        lblStars.fontSize = 30
        lblStars.fontColor = SKColor.whiteColor()
        lblStars.position = CGPoint(x: 50, y: size.height - 80)
        lblStars.horizontalAlignmentMode = .Left
        lblStars.text = String(format: "X %d", GameState.sharedInstance.stars)
        hudNode.addChild(lblStars)
        
        lblScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        lblScore.fontSize = 30
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPoint(x: size.width - 20, y: size.height - 80)
        lblScore.horizontalAlignmentMode = .Right
        lblScore.text = "0"
        hudNode.addChild(lblScore)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {
            let acceleration = $0.0.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
        })
    }
    
    func endGame() {
        gameOver = true
        GameState.sharedInstance.saveState()
        let reveal = SKTransition.fadeWithDuration(0.5)
        let endGameScene = EndGameScene(size: size)
        view!.presentScene(endGameScene, transition: reveal)
    }
    
    override func didSimulatePhysics() {
        player.physicsBody!.velocity = CGVector(dx: xAcceleration * 400, dy: player.physicsBody!.velocity.dy)
        
        if player.position.x < -20 {
            player.position = CGPoint(x: 340, y: player.position.y)
        } else if player.position.x > 340 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var updateHUD = false
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as GameObjectNode
        
        updateHUD = other.collisionWithPlayer(player)
        
        if updateHUD {
            lblStars.text = String(format: "X %d", GameState.sharedInstance.stars)
            lblScore.text = String(format: "%d", GameState.sharedInstance.score)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if player.physicsBody!.dynamic { return }
        tapToStart.removeFromParent()
        player.physicsBody!.dynamic = true
        player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 20))
        RandomThemeMusic("3")
    }
    
    func createMidgroundNode() -> SKNode {
        let theMidgroundNode = SKNode()
        var anchor: CGPoint!
        var xPosition: CGFloat!
        
        for index in 0 ..< 10 {
            var spriteName: String
            let r = arc4random() % 2
            if r > 0 {
                spriteName = "BranchRight"
                anchor = CGPoint(x: 1.0, y: 0.5)
                xPosition = self.size.width
            } else {
                spriteName = "BranchLeft"
                anchor = CGPoint(x: 0.0, y: 0.5)
                xPosition = 0.0
            }
            let branchNode = SKSpriteNode(imageNamed: spriteName)
            branchNode.anchorPoint = anchor
            branchNode.position = CGPoint(x: xPosition, y: 500 * CGFloat(index))
            theMidgroundNode.addChild(branchNode)
        }
        
        return theMidgroundNode
    }
    
    func createPlatformAtPosition(position: CGPoint, ofType type: PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.platformType = type
        node.position = thePosition
        node.name = "NODE_PLATFORM"
        
        var sprite = SKSpriteNode(imageNamed: type == .Break ? "PlatformBreak" : "Platform")
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Platform
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func createStarAtPosition(position: CGPoint, ofType type: StarType) -> StarNode {
        let node = StarNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.starType = type
        node.position = thePosition
        node.name = "NODE_STAR"
        
        
        var sprite = SKSpriteNode(imageNamed: type == .Normal ? "Star" : "StarSpecial")
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CollisionCategoryBitmask.Star
        node.physicsBody!.collisionBitMask = 0
        
        return node
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: size.width / 2, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "Player")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        playerNode.physicsBody!.dynamic = false
        playerNode.physicsBody!.friction = 0.0
        playerNode.physicsBody!.restitution = 1.0
        playerNode.physicsBody!.linearDamping = 0.0
        playerNode.physicsBody!.allowsRotation = true
        playerNode.physicsBody!.angularDamping = 0.0
        playerNode.physicsBody!.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody!.collisionBitMask = 0
        playerNode.physicsBody!.contactTestBitMask = CollisionCategoryBitmask.Star | CollisionCategoryBitmask.Platform
        playerNode.physicsBody!.usesPreciseCollisionDetection = true
        
        return playerNode
    }
    
    func createBackgroundNode() -> SKNode {
        let backgroundNode = SKNode()
        let ySpacing = 64.0 * scaleFactor
        
        for index in 0 ..< 20 {
            let node = SKSpriteNode(imageNamed: String(format: "Background%02d", index + 1))
            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            node.position = CGPoint(x: size.width / 2, y: ySpacing * CGFloat(index))
            backgroundNode.addChild(node)
        }
        
        return backgroundNode
    }
    
    override func update(currentTime: NSTimeInterval) {
        if gameOver { return }
        
        if player.position.y > 200 {
            foregroundNode.enumerateChildNodesWithName("NODE_PLATFORM", usingBlock: {
                let platform = $0.0 as PlatformNode
                platform.checkNodeRemoval(self.player.position.y)
            })
            foregroundNode.enumerateChildNodesWithName("NODE_STAR", usingBlock: {
                let star = $0.0 as StarNode
                star.checkNodeRemoval(self.player.position.y)
            })
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200) / 10))
            midgroundNode.position  = CGPoint(x: 0.0, y: -((player.position.y - 200) / 4))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 200))
        }
        
        if Int(player.position.y) > maxPlayerY {
            GameState.sharedInstance.score += Int(player.position.y) - maxPlayerY
            maxPlayerY = Int(player.position.y)
            lblScore.text = String(format: "%d", GameState.sharedInstance.score)
        }
        
        if Int(player.position.y) > endLevelY {
            endGame()
        }
        
        if Int(player.position.y) < maxPlayerY - 800 {
            endGame()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
