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
    var cgRect: CGRect?
    var xOffset, yOffset: CGFloat
    
    //convenience init(level: Int ){
    init(level: Int, levelsScene: LevelsScene, xOffset: CGFloat, yOffset: CGFloat){
        //have to call this initializer,t he other are al convenience initializers
        self.level = level
        self.xOffset = xOffset
        self.yOffset = yOffset
        super.init(
            texture: createMiniLevelGoalsTexture(levelsScene: levelsScene, xOffset: xOffset, yOffset: yOffset),//nil,
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
            
            //set offsets, after context, position can be used to modify offsets
            g.anchorPoint = CGPoint(x: 0, y: 0)
            g.position.x += self.xOffset
            g.position.y -= self.yOffset - PLAYGRIDY0!
            goals.append(g)
            
        }
        return goals
        
    }
    
    func createMiniLevelGoalsTexture(levelsScene: LevelsScene, xOffset: CGFloat, yOffset: CGFloat) -> SKTexture {
        UIGraphicsBeginImageContext(CGSize(width: MINILEVELGRIDSIZE!, height: MINILEVELGRIDSIZE!))
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        
        //create background colour rect
        let backRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let clipPath3: CGPath = UIBezierPath(roundedRect: backRect, cornerRadius: 0).cgPath
        ctx.setFillColor(UIColor.gray.cgColor)
        ctx.addPath(clipPath3)
        ctx.closePath()
        ctx.fillPath()
        
        //ctx.saveGState()
        //for lvl in 1...Json4Swift_Base.levels!.count {
        //loads goals and they draw themselves in, without offsets of what is drawn by context
        let goals = loadGoals(levelsScene: levelsScene, lvl: self.level)
        
        //create blank blob
        print("CREATING BLANK BLOB FOR LEVEL: ", self.level)
        var blobRect = CGRect(x: 1, y: 1, width: 8, height: 8) //multiplying height by -1 makes an interesting concave curve
        //blobRect.origin.x = 0
        //blobRect.origin.y = 50
        let clipPath2: CGPath = UIBezierPath(roundedRect: blobRect, cornerRadius: 24).cgPath
        ctx.setFillColor(UIColor(rgb: ColourScheme.getColour(cut: 0)).cgColor)
        //ctx.setStrokeColor(UIColor(rgb: ColourScheme.getColour(cut: 0)).cgColor)
        ctx.addPath(clipPath2)
        ctx.closePath()
        ctx.fillPath()
        //}
        
       
        
        let miniLevelImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: miniLevelImage!)
    
    }
}
