//
//  MenuScene.swift
//  Blob
//
//  Created by shunkagaya on 28/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class LevelsScene: SKScene {
    
    //array of all of the pages
    var pages = [LevelSelectPage]()
    
    //miniLevel = a small rectangular level
    //grid size is a tenth of the game grid size
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    override init(size: CGSize){
        super.init(size: size)
        //use default anchorPoint and draw everything from the middle!!!
        anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        loadLevelsScene()
    }
    // This is a duplicate... let me just find what it's a duplicate of... – nhgrif Jun 5 '15 at 23:24
    //possible duplicate of So if string is not NilLiteralConvertible... what do some string functions return? – nhgrif
    
    func loadLevelsScene(){
        //create 5 pages of 2d arrays
        var level = 1;
        for page in 1...5{
            var p: LevelSelectPage = LevelSelectPage(number: page, color: UIColor.green)
            
            for row in 0...2 {
                for column in 0...2{
                    print("adding sprite at row: \(row), column: \(column)")
                    let miniLevel: MiniLevel = MiniLevel(x: CGFloat(row), y: CGFloat(column), level: level)
                    self.addChild(miniLevel.sprite)
                    self.addChild(miniLevel.label)
                    p.levels.append(miniLevel)
                    level += 1
                }
            }
            pages.append(p)
        }
    }
}

