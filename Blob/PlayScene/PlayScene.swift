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
    var allGoalsComplete: Bool = false
    var swipeManager: SwipeManager?
    
    let BUTTONYPOSITION: CGFloat = (screenSize!.height / 20)
    let reset_button: SKSpriteNode = SKSpriteNode(imageNamed: "bttn_retry")
    let lvls_button: SKSpriteNode = SKSpriteNode(imageNamed: "bttn_levels")
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    
    override init(size: CGSize){
        super.init(size: size)
        //anchorPoint = CGPoint(x: 0.5, y: 0.55)
        //self.scaleMode = .aspectFill
        gamestate = GAMESTATE.PLAYING
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        drawDashedGrid()
        loadBlankBlob(scene: self)
        initButtons()
        self.swipeManager =  SwipeManager(scene: self, reset_button: reset_button, lvls_button: lvls_button)
        
    }
    
    func initButtons(){
        reset_button.position = CGPoint(x: (screenSize!.width / 6 * 4) - (reset_button.size.width / 2) , y: BUTTONYPOSITION)
        reset_button.name = "reset_button"
        reset_button.zPosition = 3
        reset_button.anchorPoint = CGPoint(x: 0, y: 0)
        reset_button.isUserInteractionEnabled = true
        reset_button.resizeByScreen(x: BUTTON_WIDTH_SCALE, y: BUTTON_HEIGHT_SCALE)
        
        //print("reset_button", reset_button)
        lvls_button.position = CGPoint(x: screenSize!.width / 6 * 3, y: BUTTONYPOSITION)
        lvls_button.name = "lvls_button"
        lvls_button.zPosition = 3
        lvls_button.anchorPoint = CGPoint(x: 1, y: 0)
        lvls_button.isUserInteractionEnabled = true
        lvls_button.resizeByScreen(x: BUTTON_WIDTH_SCALE, y: BUTTON_HEIGHT_SCALE)
        if(isiPad == UIUserInterfaceIdiom.pad){
            reset_button.resizeByScreen(x: BUTTON_WIDTH_SCALE * 0.9, y: BUTTON_HEIGHT_SCALE)
            lvls_button.resizeByScreen(x: BUTTON_WIDTH_SCALE * 0.9, y: BUTTON_HEIGHT_SCALE)
        }
        addChild(reset_button)
        addChild(lvls_button)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.allGoalsComplete = true
        
        for goal in goals {
            if goal.b_solved {
                if(goal.alpha < goal.MAXALPHA - goal.ALPHACHANGEAMOUNT){
                    goal.alpha += goal.ALPHACHANGEAMOUNT
                }
            }
            if !goal.b_solved {
                if(goal.alpha > goal.MINALPHA){
                    goal.alpha -= goal.ALPHACHANGEAMOUNT
                }
                self.allGoalsComplete = false
            }
        }
        if self.allGoalsComplete {
            _levelComplete()
        }
    }
    
    func _levelComplete(){
        //unlock the next level
        //write to JSON or local storage and unlock the next level
        //add next level to  unlocked levels array
        //go back to menu screen
        _toLevels()
    }
    
    func resetPlayScene(){
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED * 2)
        let playScene = PlayScene(size: self.size)
        playScene.setLevel(level: self.level!)
        self.view?.presentScene(playScene, transition: fade)
    }
    
    func _toLevels(){
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //TODO, choose which page to go to based on the level modulo 9
        let levelsScene = LevelsScene(size: self.size)
        levelsScene.setPage(currentPage: GameViewController.initCurrentPageFromLocalStorage())
        self.view?.presentScene(levelsScene, transition: fade)
    }
    
    override func didMove(to view: SKView){
        swipeManager!.handleSwipe(view: view)
    }
    
    func setLevel(level: Level){
        self.level = level
        loadGoals()
    }
    
    
    func loadBlankBlob(scene: SKScene){
        self.blobs.append(Blob(x: 1, y: 1, width: 8, height: 8, shade: 0, scene: self, isMiniLevel: false))
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
                playScene: self,
                levelsScene: nil,
                isMiniLevel: false
            )
            self.goals.append(g)
            
            //g.addChild(g.label!)
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
    

//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    print("touch began")
//    for touch in touches {
//        let location = touch.location(in: self)
//
//        if reset_button.contains(location){
//            print ("reset button touched")
//            resetPlayScene()
//        }
//        else if lvls_button.contains(location){
//            print("levels button touched")
//            _toLevels()
//        }
//    }
//}

