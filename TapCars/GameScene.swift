//
//  GameScene.swift
//  TapCars
//
//  Created by Kishan Nakum on 15/12/16.
//  Copyright © 2016 kishan nakum. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var musicPlayer : AVAudioPlayer!

    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()
    var gameOverView = SKSpriteNode()
    var startAgainButton = SKSpriteNode()
    var  mainMenuButton = SKSpriteNode()
    var pauseMainMenuButton = SKSpriteNode()
    var  resumeButton = SKSpriteNode()

    var currentScoreLabel = SKLabelNode()
    var  bestScoreLabel = SKLabelNode()
    var countDown = 1


    var center : CGFloat!
    var gameOver = false
    var isGamePause = false
    var stopEverything = true

    let leftCarMinimumX : CGFloat = -280
    let leftCarMaximumX : CGFloat = -100
    
    let rightCarMinimumX : CGFloat = 100
    let rightCarMaximumX : CGFloat = 280
    
    var canMove = false
    var leftCarToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtLeft = false
    var rightCarAtRight = false

    private var scoreBand = SKLabelNode()
    private var score = 0

    
    override func didMove(to view: SKView) {
        setUp()
        musicPlayer = helper().setupAudioPlayerWithFile("Frantic-Gameplay", type: "mp3")
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.3
        physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target:self, selector: #selector(GameScene.setUpRoadStrip), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(helper().randomBetweenNumbers(firstNum: 0.1, secondNum: 1.5)), target:self, selector: #selector(GameScene.setUpTreeNRock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self, selector: #selector(GameScene.startCarsCountDown), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(helper().randomBetweenNumbers(firstNum: 0.8, secondNum:1.8)), target:self, selector: #selector(GameScene.setUpLeftBarrel), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(helper().randomBetweenNumbers(firstNum: 0.8, secondNum:1.8)), target:self, selector: #selector(GameScene.setUpRightBarrel), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(3), target:self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        
        let deadlineTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self, selector: #selector(GameScene.countScore), userInfo: nil, repeats: true)
        })


    }
    
    override func update(_ currentTime: TimeInterval) {
        showRoadStrip()
        if canMove {
            move(leftSide: leftCarToMoveLeft)
            moveForB(rightSide: rightCarToMoveRight)
        }
        if gameOver{
        gameOverViewToFront()
        }
        if isGamePause{
            pauseButtonClicked()
        }
        
        if countDown == 0 {
            resumeButtonClicked()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar") && (contact.bodyB.node?.name == "orangePoint" || contact.bodyB.node?.name == "bluePoint") {
            self.run(SKAction.playSoundFileNamed("point.mp3", waitForCompletion: false))
            secondBody.node?.removeFromParent()
            score += 1
            scoreBand.text = String(score)
        }else{
            self.run(SKAction.playSoundFileNamed("dead.wav", waitForCompletion: false))
            firstBody.node?.removeFromParent()
            gameOver = true
            stopEverything = true
            currentScoreLabel.text = "Score : \(score)"
            bestScoreLabel.text = "Best : \(score)"
        }
            }

    
    
    func setUp(){
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        gameOverView = self.childNode(withName: "gameOver") as! SKSpriteNode
        startAgainButton = self.childNode(withName: "startAgain") as! SKSpriteNode
        mainMenuButton = self.childNode(withName: "mainMenu") as! SKSpriteNode
        currentScoreLabel = self.childNode(withName: "currentScore") as! SKLabelNode
        bestScoreLabel = self.childNode(withName: "bestScore") as! SKLabelNode
        pauseMainMenuButton = self.childNode(withName: "pauseMainMenu") as! SKSpriteNode
        resumeButton = self.childNode(withName: "resumeButton") as! SKSpriteNode

        leftCar.physicsBody?.categoryBitMask = colliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = colliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        rightCar.physicsBody?.categoryBitMask = colliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = colliderType.ITEM_COLLIDER_1
        rightCar.physicsBody?.collisionBitMask = 0

        center = self.frame.size.width / self.frame.size.height
        
        //setup for score
        let back = SKShapeNode(rect: CGRect(x:-self.size.width/2 + 70, y: self.size.height/2 - 130, width: 180, height: 80), cornerRadius: 20)
        back.zPosition = 4
        back.fillColor = SKColor.black.withAlphaComponent(0.3)
        back.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(back)
        
        scoreBand.name = "score"
        scoreBand.fontName = "AvenirNext-Bold"
        scoreBand.text = "0"
        scoreBand.position = CGPoint(x: -self.size.width/2 + 160 , y:self.size.height/2 - 110)
        scoreBand.fontColor = SKColor.white
        scoreBand.fontSize = 50
        scoreBand.zPosition = 4
        scoreBand.horizontalAlignmentMode = .center
        addChild(scoreBand)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "pause"{
                if !stopEverything{
                isGamePause = true
                stopEverything = true
                }

            }else if atPoint(touchLocation).name == "startAgain"{
                let gamePlayScene = SKScene(fileNamed: "GameScene")!                // Set the scale mode to scale to fit the window
                gamePlayScene.scaleMode = .aspectFill
                musicPlayer.stop()
                view?.presentScene(gamePlayScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
 
            }else if atPoint(touchLocation).name == "mainMenu" || atPoint(touchLocation).name == "pauseMainMenu"{
                let gamePlayScene = SKScene(fileNamed: "Menu")!                // Set the scale mode to scale to fit the window
                gamePlayScene.scaleMode = .aspectFill
                musicPlayer.stop()
                view?.presentScene(gamePlayScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(1)))
                
            }else if atPoint(touchLocation).name == "resumeButton"{
                isGamePause = false
                countDown = 0
            }else{
            if touchLocation.x > center! {
                if rightCarAtRight{
                    rightCarAtRight = false
                    rightCarToMoveRight = true
                }else{
                    rightCarAtRight = true
                    rightCarToMoveRight = false
                }
                
            }else{
                if leftCarAtLeft{
                    leftCarAtLeft = false
                    leftCarToMoveLeft = true
                }else{
                    leftCarAtLeft = true
                    leftCarToMoveLeft = false
                }
                
            }
            }
        }
        canMove = true
        
    }

    func move(leftSide:Bool){
        
        if leftSide{
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarMinimumX{
                leftCar.position.x = leftCarMinimumX
            }
        }else{
            leftCar.position.x += 20
            if leftCar.position.x > leftCarMaximumX{
                leftCar.position.x = leftCarMaximumX
            }
        }
    }
    
    func moveForB(rightSide:Bool){
        
        if rightSide{
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaximumX{
                rightCar.position.x = rightCarMaximumX
            }

        }else{
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinimumX{
                rightCar.position.x = rightCarMinimumX
            }
        }
    }
  
    func setUpRoadStrip(){
        if !stopEverything  {
        let leftRoadStrip = SKShapeNode(rectOf:CGSize(width: 10, height: 40))
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip = SKShapeNode(rectOf:CGSize(width: 10, height: 40))
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "leftRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
        }
    }
    
    func setUpLeftBarrel(){
        if !stopEverything {
        let leftBarrel : SKSpriteNode!
        let randomItem =  helper().randomBetweenNumbers(firstNum: 1, secondNum: 10)
        switch Int(randomItem) {
        case 1...4:
            leftBarrel = SKSpriteNode(imageNamed: "orangeCar")
            leftBarrel.name = "barrel"

            break
        case 5...8:
            leftBarrel = SKSpriteNode(imageNamed: "yellowCar")
            leftBarrel.name = "yellowCar"

            break
        case 9,10:
            leftBarrel = SKSpriteNode(imageNamed: "greenCar")
            leftBarrel.name = "greenCar"
            break

        default:
            leftBarrel = SKSpriteNode(imageNamed: "orangePoint")
            leftBarrel.name = "barrel"
        }
        
//        leftBarrel.setScale(1.5)
        leftBarrel.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        leftBarrel.zPosition = 10
        let num = helper().randomBetweenNumbers(firstNum: 1, secondNum: 10)
        switch Int(num) {
        case 1...5:
            leftBarrel.position.x = -280
            break
        case 5...10:
            leftBarrel.position.x = -90
            break
        default:
            print("ntng")
        }
        leftBarrel.physicsBody = SKPhysicsBody(circleOfRadius: leftBarrel.size.height/2)
        leftBarrel.physicsBody?.affectedByGravity = false
        leftBarrel.physicsBody?.categoryBitMask = colliderType.ITEM_COLLIDER
        leftBarrel.physicsBody?.collisionBitMask = 0
        leftBarrel.position.y = helper().randomBetweenNumbers(firstNum: 700, secondNum: 800)
        addChild(leftBarrel)
        }
    }
    
    func setUpRightBarrel(){
        if !stopEverything {
        let rightBarrel : SKSpriteNode!
        let randomItem =  helper().randomBetweenNumbers(firstNum: 1, secondNum: 10)
        switch Int(randomItem) {
        case 1...4:
            rightBarrel = SKSpriteNode(imageNamed: "orangeCar")
            rightBarrel.name = "barrel"
            
            break
        case 5...8:
            rightBarrel = SKSpriteNode(imageNamed: "yellowCar")
            rightBarrel.name = "yellowCar"
            break
        case 9,10:
            rightBarrel = SKSpriteNode(imageNamed: "greenCar")
            rightBarrel.name = "greenCar"
            break

        default:
            rightBarrel = SKSpriteNode(imageNamed: "orangePoint")
            rightBarrel.name = "barrel"
        }
        
//        rightBarrel.setScale(1.5)
        rightBarrel.anchorPoint = CGPoint (x: 0.5, y: 0.5)
        rightBarrel.zPosition = 10
        rightBarrel.physicsBody = SKPhysicsBody(circleOfRadius: rightBarrel.size.height/2)
        rightBarrel.physicsBody?.affectedByGravity = false
        rightBarrel.physicsBody?.categoryBitMask = colliderType.ITEM_COLLIDER_1
        rightBarrel.physicsBody?.collisionBitMask = 0
        let num = helper().randomBetweenNumbers(firstNum: 1, secondNum: 11)
        switch Int(num) {
        case 1...5:
            rightBarrel.position.x = 280
            break
        case 5...10:
            rightBarrel.position.x = 90
            break
        case 5...10:
            rightBarrel.position.x = 187.5
            break

        default:
            print("ntng")
        }
        rightBarrel.position.y = helper().randomBetweenNumbers(firstNum: 700, secondNum: 800)
        addChild(rightBarrel)
    }
}
    
    func showRoadStrip(){
        if !stopEverything {

        enumerateChildNodes(withName: "leftRoadStrip") {
            roadStrip, stop in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        }
        enumerateChildNodes(withName: "treeNrock") {
            roadStrip, stop in
            let strip = roadStrip as! SKSpriteNode
            strip.position.y -= 25
        }
        
        enumerateChildNodes(withName: "barrel") {
            roadStrip, stop in
            let strip = roadStrip as! SKSpriteNode
            strip.position.y -= 10
        }
            
            enumerateChildNodes(withName: "yellowCar") {
                roadStrip, stop in
                let strip = roadStrip as! SKSpriteNode
                strip.position.y -= 15
            }
            
            enumerateChildNodes(withName: "greenCar") {
                roadStrip, stop in
                let strip = roadStrip as! SKSpriteNode
                strip.position.y -= 15
            }


        }

    }
    
    func setUpTreeNRock(){
        if !stopEverything {
        let treeNrock = TreeNRock()
        treeNrock.intializeItem()
        treeNrock.position.x = 0
        treeNrock.position.y = 700
        addChild(treeNrock)
        }
    }
    
    func removeItems(){
        for child in children{
                if child.position.y < -self.size.height - 100 {
                    child.removeFromParent()
                }
        }
    }

    func gameOverViewToFront(){
        gameOverView.position.y -= 10
        if gameOverView.position.y < 0 {
            gameOverView.position.y = 0
        }
        
        startAgainButton.position.y -= 10
        if startAgainButton.position.y < -100 {
            startAgainButton.position.y = -100
        }

        mainMenuButton.position.y -= 10
        if mainMenuButton.position.y < -210 {
            mainMenuButton.position.y = -210
        }
        
        currentScoreLabel.position.y -= 10
        if currentScoreLabel.position.y < 50 {
            currentScoreLabel.position.y = 50
        }

        
        bestScoreLabel.position.y -= 10
        if bestScoreLabel.position.y < -20 {
            bestScoreLabel.position.y = -20
        }



    }
    
    func pauseButtonClicked(){
        pauseMainMenuButton.position.x -= 10
        if pauseMainMenuButton.position.x < 0 {
            pauseMainMenuButton.position.x = 0
        }
        
        resumeButton.position.x -= 10
        if resumeButton.position.x < 0 {
            resumeButton.position.x = 0
        }
    }
    
    func startCarsCountDown(){
        if countDown > 0{
        if countDown < 4{
        let countDownLabel = SKLabelNode()
        countDownLabel.fontName = "AvenirNext-Bold"
            countDownLabel.name = "cLabel"
        countDownLabel.text = String(countDown)
        countDownLabel.position = CGPoint(x:0 , y:0)
        countDownLabel.fontColor = SKColor.white
        countDownLabel.fontSize = 300
        countDownLabel.zPosition = 300
        countDownLabel.horizontalAlignmentMode = .center
        addChild(countDownLabel)
            let deadlineTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                countDownLabel.removeFromParent()
            })
        }
        countDown += 1
        if self.countDown == 4{
            musicPlayer.play()
            self.stopEverything = false
        }
        }
        
    }
    
    func resumeButtonClicked(){
        pauseMainMenuButton.position.x += 10
        if pauseMainMenuButton.position.x > 610 {
            pauseMainMenuButton.position.x = 610
            countDown = 1
        }
        
        resumeButton.position.x += 10
        if resumeButton.position.x > 610 {
            resumeButton.position.x = 610
            countDown = 1
        }

    }
    
    func countScore(){
        if !stopEverything{
        score += 1
        scoreBand.text = String(score)
    }
    }
    
}
