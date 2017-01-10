//
//  TreeNRock.swift
//  TapCars
//
//  Created by Kishan Nakum on 15/12/16.
//  Copyright © 2016 kishan nakum. All rights reserved.
//

import Foundation
import SpriteKit


class TreeNRock : SKSpriteNode {
    
    func intializeItem(){
        
        let randomNumber = helper().randomBetweenNumbers(firstNum: 1, secondNum: 10)
        if randomNumber > 2{
            let wormTexture = SKTexture(image: UIImage(named:"tree")!)
            self.texture = wormTexture
            self.name = "treeNrock"
        }else{
            let bombTexture = SKTexture(image: UIImage(named:"rock")!)
            self.texture = bombTexture
            self.name = "treeNrock"
        }
        self.size = CGSize(width: 100, height: 100)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 10
    }
    
}
