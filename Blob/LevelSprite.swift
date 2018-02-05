//
//  LevelSprite.swift
//  Blob
//
//  Created by shunkagaya on 18/12/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//
// for identifying each sprite representing the level choice

import SpriteKit

class LevelSprite : SKSpriteNode {
    
    var level: Int = 0
    var levelsScene: LevelsScene?
    
    //convenience init(level: Int ){
    init(level: Int, levelsScene: LevelsScene){
        //have to call this initializer,t he other are al convenience initializers
        super.init(texture: nil, color: UIColor.black, size: CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!))
        self.level = level
        self.levelsScene = levelsScene
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //self.level = 0
        //super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("level: \(self.level) was touched")
        
        //load the touched level
        let lvlTitle = json4Swift_Base?.getLevelTitle(lvlNo: self.level)
        let lvlNo = json4Swift_Base?.getLevelNo(lvlNo: self.level)
        let lvlGoals: Array<Goals> = (json4Swift_Base?.getLevelGoals(lvlNo: self.level))!
        
        //create a level
        let t_level = Level(lvlNo: lvlNo!, lvlTitle: lvlTitle!, goals: lvlGoals)
        self.levelsScene?._goToPlayScene(level: t_level)
    }
    
    
}
