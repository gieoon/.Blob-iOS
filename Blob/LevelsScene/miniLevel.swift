//
//  miniLevel.swift
//  Blob
//
//  Created by shunkagaya on 02/12/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

//just hardcode this shit
var miniLevelPositions = Array<CGRect>()

struct MiniLevel{
    var x: CGFloat
    var y: CGFloat
    var level: Int
    var sprite: SKSpriteNode//initSprite()
    //temporary label to display number of the level
    var label = SKLabelNode()
    var locked: Bool
    
//hamburger approach, the negative is sandwiched between two positives.
    init(x: CGFloat, y: CGFloat, level: Int, levelsScene: LevelsScene){
        self.x = x
        self.y = y
        self.level = level
        self.locked = !(DataStorage._sharedInstance.dataToSave.unlockedLvl! > level)
        self.sprite = LevelSprite(
            level: self.level,
            levelsScene: levelsScene,
            xOffset: (x * PAGEGRIDSIZE!) + (PAGEGRIDSIZE! / 3),//(screenSize!.width / 10 * 1.2),
            yOffset: (screenSize!.height / 2)  - (y * PAGEGRIDSIZE!) + (screenSize!.height / 6.5),
            //(screenSize!.height / 2) - (y * PAGEGRIDSIZE!) + (screenSize!.height / 4.5)
            locked: self.locked
        )
            
        //sprite.size = CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        //sprite.color = SKColor.black
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        //sprite.yScale = -1;
        //changing sprite position does not change anything, as goals are being rendered for themselves
        sprite.position = CGPoint(
            x: (x * PAGEGRIDSIZE!) + (PAGEGRIDSIZE! / 3),//(screenSize!.width / 10 * 1.2),
            y: (screenSize!.height / 2)  - (y * PAGEGRIDSIZE!) + (screenSize!.height / 6.5)
        )
        //sprite.posByScreen(x: -0.1, y: <#T##CGFloat#>)
        //sprite.position = CGPoint(x: 0, y: 0)
        //print("sprite.position is: \(sprite.position)")
        sprite.isUserInteractionEnabled = locked ? false : true
        //sprite.touchesBegan(<#T##touches: Set<UITouch>##Set<UITouch>#>, with: <#T##UIEvent?#>)
        
        //draw temporary level label
        label.text = String(self.level)
        //label.font = UIFontMetrics.default.scaledFont(for: CUSTOMFONT)
        label.fontName = CUSTOMFONT.fontName
        label.fontColor = SKColor.white
        //label.adjustsFontForContentSizeCategory = true
        label.position = sprite.position
        label.position.x += screenSize!.width / 15
        label.position.y += screenSize!.height / 20
        label.zPosition = 3
        //levelsScene.addChild(label)
        //label.yScale = -1;
    }
}

//another way of doing it is by extending SKSpriteNode, and then calling that class from aother place.
//wysiwym (what you see is what you mean)
