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
        self.level = level
        super.init(
            texture: createMiniLevelGoalsTexture(levelsScene: levelsScene),
            color: UIColor.black,
            size: CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!,
                         height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        )
    
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
        let lvlGoals: Array<Goals> = (Json4Swift_Base.getLevelGoals(lvlNo: self.level))
        
        //create a level
        let t_level = Level(lvlNo: lvlNo!, lvlTitle: lvlTitle!, goals: lvlGoals)
        self.levelsScene?._goToPlayScene(level: t_level)
    }
    
    func loadGoals(levelsScene: LevelsScene, lvl: Int) -> Array<Goal>{
        
        var goals = Array<Goal>()
        let inputGoals = Json4Swift_Base.getLevelGoals(lvlNo: lvl)
        //create a new Goal from Goals type & draw each goal
        for goal in inputGoals {
            
            let g = Goal(
                targetDirection: goal.getTargetDirection(),
                start: goal.getGoalStart(),
                length: goal.getGoalLength(),
                targetShade: goal.getGoalShade(),
                playScene: nil,
                levelsScene: levelsScene,
                isMiniLevel: true
            )
            goals.append(g)
        }
        return goals
        
    }
    
    func createMiniLevelGoalsTexture(levelsScene: LevelsScene) -> SKTexture {
        UIGraphicsBeginImageContext(CGSize(width: MINILEVELGRIDSIZE!, height: MINILEVELGRIDSIZE!))
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        //ctx.saveGState()
        //for lvl in 1...Json4Swift_Base.levels!.count {
        let goals = loadGoals(levelsScene: levelsScene, lvl: self.level)
        for goal in goals {
            print("CREATING ONE GOAL")
            let goalRect = goal.createGoalRect(
                targetDirection: goal.targetDirection!,
                start: goal.start!,
                length: goal.length!)
            
            let clipPath: CGPath = UIBezierPath(roundedRect: goalRect, cornerRadius: 8).cgPath
            ctx.addPath(clipPath)
            
            let color = UIColor(rgb: ColourScheme.getColour(cut: goal.targetShade!)).cgColor
            
            ctx.setFillColor(color)
            
            ctx.closePath()
            ctx.fillPath()
            //ctx.restoreGState()
            
        }
        //create blank blob
        print("CREATING BLANK BLOB FOR LEVEL")
        let blobRect = CGRect(x: 1, y: 1, width: 8, height: 8) //multiplying height by -1 makes an interesting concave curve
        let clipPath2: CGPath = UIBezierPath(roundedRect: blobRect, cornerRadius: 24).cgPath
        ctx.addPath(clipPath2)
        //}
        
        
        let miniLevelImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: miniLevelImage!)
    
    }
}
