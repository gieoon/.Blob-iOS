//
//  miniLevel.swift
//  Blob
//
//  Created by shunkagaya on 02/12/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

struct MiniLevel{
    let x: CGFloat
    let y: CGFloat
    let level: Int
    let sprite = SKSpriteNode()//initSprite()
    //temporary label to display number of the level
    let label = SKLabelNode()
    
//hamburger approach, the negative is sandwiched between two positives.
    init(x: CGFloat, y: CGFloat, level: Int){
        self.x = x
        self.y = y
        self.level = level
        sprite.size = CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        sprite.color = SKColor.black
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.position = CGPoint(x: (x * PAGEGRIDSIZE!) + (screenSize!.width / 10 * 1.2), y: (y * PAGEGRIDSIZE!) + (screenSize!.height / 4.5))
        //sprite.posByScreen(x: -0.1, y: <#T##CGFloat#>)
        //sprite.position = CGPoint(x: 0, y: 0)
        print("sprite.position is: \(sprite.position)")
        //sprite.touchesBegan(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        
        //draw temporary level label
        label.text = String(self.level)
        label.fontSize = 32
        label.fontColor = SKColor.white
        label.position = sprite.position
        
    }
    
    func initSprite(){
        //var rect = SKSpriteNode(color: SKColor.black)
    }
    
    //click listener
}

//another way of doing it is by extending SKSpriteNode, and then calling that class from aother place.
//wysiwym (what you see is what you mean)
