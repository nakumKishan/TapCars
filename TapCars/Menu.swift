//
//  Menu.swift
//  TapCars
//
//  Created by Kishan Nakum on 16/12/16.
//  Copyright © 2016 kishan nakum. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Menu : SKScene{
    
    var car : SKSpriteNode!
    var arrowDefaultHeight : CGFloat!
    var canMove = false
    var car1 : SKSpriteNode!
    var car2 : SKSpriteNode!
    var startGameLabel : SKLabelNode!
    var settings : SKLabelNode!
    var musicPlayer : AVAudioPlayer!
    var gameCamera : SKCameraNode!
    var backFromSettings : SKSpriteNode!
    var soundButton : SKLabelNode!
    var howToPlay : SKLabelNode!
    var backFromHowToPlay : SKSpriteNode!




    override func didMove(to view: SKView) {
        // SpriteNode I want to drag around
        car  = childNode(withName: "arrow") as! SKSpriteNode!
        car1  = childNode(withName: "car1") as! SKSpriteNode!
        car2  = childNode(withName: "car2") as! SKSpriteNode!
        gameCamera  = childNode(withName: "gameCamera") as! SKCameraNode!
        startGameLabel = childNode(withName: "startGame") as! SKLabelNode!
        settings = childNode(withName: "Settings") as! SKLabelNode!
        backFromSettings  = childNode(withName: "backFromSettings") as! SKSpriteNode!
        soundButton = childNode(withName: "soundButton") as! SKLabelNode!
        howToPlay = childNode(withName: "howToPlayButton") as! SKLabelNode!
        backFromHowToPlay  = childNode(withName: "backFromHowToPlay") as! SKSpriteNode!


        arrowDefaultHeight = car.position.y
        musicPlayer = helper().setupAudioPlayerWithFile("destination-01", type: "mp3")
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.3

    }
    
    override func update(_ currentTime: TimeInterval) {
        if canMove {
            move()
        }
    }

    func move(){
            car1.position.y += 15
            car2.position.y += 15
        startGameLabel.position.y += 15
        settings.position.y += 15
        if startGameLabel.position.y > 93{
            startGameLabel.position.y = 93
        }
        if settings.position.y > -43{
            settings.position.y = -43
        }

    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "arrow"{
            car.position.y = location.y
                if location.y < -170{
                  car.removeFromParent()
                    canMove = true
                self.run(SKAction.playSoundFileNamed("Race Car Sound Effect.mp3", waitForCompletion: false))
                }
        }
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "startGame"{
                let gamePlayScene = SKScene(fileNamed: "GameScene")!                // Set the scale mode to scale to fit the window
                gamePlayScene.scaleMode = .aspectFill
                musicPlayer.stop()
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                view?.presentScene(gamePlayScene, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(3)))
            }else if atPoint(location).name == "Settings"{
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                gameCamera.position.x = (self.view?.frame.width)!*2
            }else if atPoint(location).name == "backFromSettings"{
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                gameCamera.position.x = 0
            }else if atPoint(location).name == "soundButton"{
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                if soundButton.text == "ON"{
                    soundButton.text = "OFF"
                }else{
                    soundButton.text = "ON"
                }
            }else if atPoint(location).name == "howToPlayButton"{
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                gameCamera.position.x = (self.view?.frame.width)!*4
            }else if atPoint(location).name == "backFromHowToPlay"{
                self.run(SKAction.playSoundFileNamed("menuSelect.mp3", waitForCompletion: false))
                gameCamera.position.x = (self.view?.frame.width)!*2
            }

            }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "arrow"{
                if location.y >= -170{
                    car.position.y = arrowDefaultHeight
                }
                
            }
        }
    }
    

    
}
