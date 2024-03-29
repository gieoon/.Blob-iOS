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
    weak var levelsScene: LevelsScene?
    var cgRect: CGRect?
    var xOffset, yOffset: CGFloat
    var locked: Bool
    
    //convenience init(level: Int ){
    init(level: Int, levelsScene: LevelsScene, xOffset: CGFloat, yOffset: CGFloat, locked: Bool){
        //have to call this initializer,t he other are al convenience initializers
        self.level = level
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.locked = locked
        super.init(
            texture:
            createMiniLevelGoalsTexture(levelsScene: levelsScene, xOffset: xOffset, yOffset: self.yOffset, locked: locked),//nil,
            color: UIColor.black,
            size: CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!,
                         height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        )
        //self.physicsBody = nil
        
//        miniLevelPositions.append(CGRect(
//            x: self.xOffset,
//            y: self.yOffset,
//            width: self.size.width,
//            height: self.size.height
//        ))
    
        self.levelsScene = levelsScene
        self.name = "levelSprite"
        self.zPosition = 2
        isUserInteractionEnabled = locked ? false : true
        
        if !locked { loadGoals(levelsScene: levelsScene, lvl: self.level) }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //made redundant due to not being able to "touch-through"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.locked {
            print("level: \(self.level) was touched")
            
            //load the touched level
            var lvlTitle = json4Swift_Base?.getLevelTitle(lvlNo: self.level)
            var lvlNo = json4Swift_Base?.getLevelNo(lvlNo: self.level)
            var lvlGoals: Array<Goals> = (Json4Swift_Base.getLevelGoals(lvlNo: self.level))
            
            //create a level
            var t_level = Level(lvlNo: lvlNo!, lvlTitle: lvlTitle!, goals: lvlGoals)
            self.levelsScene?._goToPlayScene(level: t_level)
        }
    }
    
    func loadGoals(levelsScene: LevelsScene, lvl: Int){
        
        //var goals = Array<Goal>()
        var inputGoals = Json4Swift_Base.getLevelGoals(lvlNo: lvl)
        //create a new Goal from Goals type & draw each goal
        for goal in inputGoals {
            
            var g = Goal(
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
            //g.position.x += (g.cgRect?.origin.x)!
            //g.position.y = screenSize!.height - (g.cgRect?.origin.y)!
            g.position.y += self.yOffset
            
            g.goalStrokeSprite?.position.x += self.xOffset
            g.goalStrokeSprite?.position.y += self.yOffset
            
            //print("LEVEL: ", self.level, " yOffset is: ", yOffset) //THIS ONE OUTPUT COMMENT FINALLY MADE IT WORK!!!
            //g.position.y += PAGEMARGINSIZE!
            //g.position.y += PAGEGRIDSIZE!
            //g.label!.position.x += self.xOffset
            //g.label!.position.y += self.yOffset// - PLAYGRIDY0! - (MINILEVELGRIDSIZE! * 2.65) //don't ask me why this offset exists
            //goals.append(g)
            
        }
        //print("ALL GOALS LOADED")
    }
    
    func createMiniLevelGoalsTexture(levelsScene: LevelsScene, xOffset: CGFloat, yOffset: CGFloat, locked: Bool) -> SKTexture {
        UIGraphicsBeginImageContext(CGSize(
            width: PAGEGRIDSIZE! - PAGEMARGINSIZE!,
            height: PAGEGRIDSIZE! - PAGEMARGINSIZE!))
        var ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        
        //create background colour rect
        var backRect = CGRect(
            x: 0 * MINILEVELGRIDSIZE!,
            y: 0 * MINILEVELGRIDSIZE!,
            width: 10 * MINILEVELGRIDSIZE!,
            height: 10 * MINILEVELGRIDSIZE!)
        var clipPath3: CGPath = UIBezierPath(roundedRect: backRect, cornerRadius: 0).cgPath
        ctx.setFillColor(UIColor.gray.withAlphaComponent(0.05).cgColor)
        ctx.addPath(clipPath3)
        ctx.closePath()
        ctx.fillPath()
        
        //ctx.saveGState()
        //for lvl in 1...Json4Swift_Base.levels!.count {
        //loads goals and they draw themselves in, without offsets of what is drawn by context
        
        
        //create blank blob
        //print("CREATING BLANK BLOB FOR LEVEL: ", self.level)
        var blobRect = CGRect(
            x: 1 * MINILEVELGRIDSIZE!,
            y: 1 * MINILEVELGRIDSIZE!,
            width: 8 * MINILEVELGRIDSIZE!,
            height:  8 * MINILEVELGRIDSIZE!) //multiplying height by -1 makes an interesting concave curve
        var clipPath2: CGPath = UIBezierPath(roundedRect: blobRect, cornerRadius: 8).cgPath
        
        ctx.setFillColor(
            locked ? UIColor.gray.cgColor :
            UIColor(rgb: ColourScheme.getColour(cut: 0)).cgColor)
        //ctx.setStrokeColor(UIColor(rgb: ColourScheme.getColour(cut: 0)).cgColor)
        ctx.addPath(clipPath2)
        ctx.closePath()
        ctx.fillPath()
        //}
        
       
        
        var miniLevelImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: miniLevelImage!)
    
    }
}
