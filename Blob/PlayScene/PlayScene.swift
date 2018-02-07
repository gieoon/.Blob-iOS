//
//  PlayScene.swift
//  Blob
//
//  Created by USER on 20@objc 18/02/02.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    
    var level: Level?
    //can also use sta@objc tic variables mate
    var blobs = Array<Blob>()
    var inputGoals = Array<Goals>()
    var goals = Array<Goal>()
    lazy var swipeManager: SwipeManager = SwipeManager(scene: self)
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    
    override init(size: CGSize){
        super.init(size: size)
        //anchorPoint = CGPoint(x: 0.5, y: 0.55)
        //self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        drawDashedGrid()
        //loadBlankBlob(scene: self)
        
        
    }
    
    override func didMove(to view: SKView){
        swipeManager.handleSwipe(view: view)
    }
    
    func setLevel(level: Level){
        self.level = level
        loadGoals()
    }
    
    
    func loadBlankBlob(scene: SKScene){
        self.blobs.append(Blob(x: 1, y: 1, width: 8, height: 8, shade: 0, scene: self))
    }
    
    func loadGoals(){
        self.inputGoals = Json4Swift_Base.getLevelGoals(lvlNo: (self.level?.lvlNo)!)
        //create a new Goal from Goals type & draw each goal
        
        for goal in self.inputGoals {
            
            let g = Goal(
                targetDirection: goal.getTargetDirection(),
                start: goal.getGoalStart(),
                length: goal.getGoalLength(),
                targetShade: goal.getGoalShade(),
                scene: self
            )
            self.goals.append(g)
            //scene?.addChild(g)
            scene?.addChild(g.label)
        }
    }
    
    func drawDashedGrid(){
        let dashPattern : [CGFloat] = [0.15, 5.5]
        //draw dotted line representing grid
        
        //UIGraphicsBeginImageContext(scene!.size)
        //let ctx: CGContext = UIGraphicsGetCurrentContext()!
        //did this using CGContext, CGMutablePath, and UIBezierPath, until finally one worked...
        //all of those have a different coordinate system...CGContext 0 is in the middle of screen, while UIBezier Path is top left...
        for row in 1...9 {
            //let path = CGMutablePath()
            let path = UIBezierPath()
            
            //path.copy(dashingWithPhase: 2, lengths: pattern)
            
            
//            ctx.saveGState()
//            ctx.beginPath()
//            ctx.setLineWidth(8.0)
//            ctx.setLineCap(.round)
//            ctx.setStrokeColor(UIColor.black.cgColor)
//            ctx.setFillColor(UIColor.black.cgColor)
            
            
            let point0 = CGPoint(x: PLAYGRIDSIZE! * 0.5, y: (CGFloat(row) * PLAYGRIDSIZE!) + PLAYGRIDY0!)
            //let point0 = CGPoint(x: 0, y: 0)
            path.move(to: point0)
            //path.addLine(to: point0)
            //ctx.move(to: point0)
            //ctx.addLine(to: point0)
            
            let point1 = CGPoint(x: PLAYGRIDSIZE! * 9.5, y: (CGFloat(row) * PLAYGRIDSIZE!) + PLAYGRIDY0!)
            //let point1 = CGPoint(x: 375, y: 667)
            path.addLine(to: point1)
            //ctx.move(to: point1)
            //ctx.addLine(to: point1)
            
            //let dashes: [ CGFloat ] = [ 0, PLAYGRIDSIZE!, PLAYGRIDSIZE! * 2, PLAYGRIDSIZE! * 3, PLAYGRIDSIZE! * 4, PLAYGRIDSIZE! * 5 ]
            //ctx.setLineDash(phase: 0.0, lengths: dashes)
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.lineCapStyle = CGLineCap.round
            //path.lineCapStyle = .butt
            
            let renderer = UIGraphicsImageRenderer(size: scene!.size)
            let dashedImage = renderer.image {
                context in path.stroke(with: CGBlendMode.normal, alpha: 0.3)
            }
            //scene?.addChild(renderer)
//            let shape = SKShapeNode(path: path.copy(dashingWithPhase: 2, lengths: dashPattern))
//            shape.path = path
//            shape.strokeColor = UIColor.black
//            shape.lineWidth = 2
//            addChild(shape)
            //ctx.strokePath()
            //print("SHAPE.path IS: ", shape.path)
            
//            let dashedImage = UIGraphicsGetImageFromCurrentImageContext()
            let dashedTexture = SKTexture(image: dashedImage)
            let dashedSprite = SKSpriteNode(texture: dashedTexture)
            dashedSprite.anchorPoint = CGPoint(x: 0, y: 0)
            scene?.addChild(dashedSprite)
            //print(dashedSprite)
            
            //ctx.closePath()
            //ctx.fillPath()
            //ctx.restoreGState()
        }
        //UIGraphicsEndImageContext()
        
        for column in 1...9 {
            let path = UIBezierPath()
            
            let point0 = CGPoint(x: CGFloat(column) * PLAYGRIDSIZE!, y: (PLAYGRIDSIZE! * 0.5) + PLAYGRIDY0!)
            path.move(to: point0)
            
            let point1 = CGPoint(x: CGFloat(column) * PLAYGRIDSIZE!, y: (PLAYGRIDSIZE! * 9.5) + PLAYGRIDY0!)
            path.addLine(to: point1)
            
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.lineCapStyle = CGLineCap.round
            //path.lineCapStyle = .butt
            
            let renderer = UIGraphicsImageRenderer(size: scene!.size)
            let dashedImage = renderer.image {
                context in path.stroke(with: CGBlendMode.lighten, alpha: 0.3)
            }

            let dashedTexture = SKTexture(image: dashedImage)
            let dashedSprite = SKSpriteNode(texture: dashedTexture)
            dashedSprite.anchorPoint = CGPoint(x: 0, y: 0)
            scene?.addChild(dashedSprite)
        }
    }
}

//        ctx.drawPath(using: CGPathDrawingMode.eoFillStroke)



//        let lineImage = UIGraphicsGetImageFromCurrentImageContext()
//        let lineTexture = SKTexture(image: lineImage!)
//        let lineSprite = SKSpriteNode(texture: lineTexture)
//bring big bag, and go to Donna's place later, do some coding, then visit Anita. Take care of her and the stuff there, then move on aye...

//print("LINESPRITE IS: ", lineSprite)
//        scene!.addChild(lineSprite)
    

