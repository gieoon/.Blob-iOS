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
    let sprite = SKSpriteNode()//initSprite()
//hamburger approach, the negative is sandwiched between two positives.
    init(x: CGFloat, y: CGFloat){
        self.x = x
        self.y = y
        sprite.size = CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        sprite.color = SKColor.black
        //sprite.anchorPoint = CGPoint(x: 1.0, y: 0)
        sprite.position = CGPoint(x: (x * PAGEGRIDSIZE!) + (PAGEMARGINSIZE! * 2), y: (y * PAGEGRIDSIZE!) + (PAGEMARGINSIZE! * 2))
        //sprite.posByScreen(x: -0.1, y: <#T##CGFloat#>)
        //sprite.position = CGPoint(x: 0, y: 0)
        print("sprite.position is: \(sprite.position)")
        //sprite.touchesBegan(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
    }
    
    func initSprite(){
        //var rect = SKSpriteNode(color: SKColor.black)
    }
    
    //click listener
}

//another way of doing it is by extending SKSpriteNode, and then calling that class from aother place.
//wysiwym (what you see is what you mean)
