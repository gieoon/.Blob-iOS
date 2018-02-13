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
    //var dashedSprite: SKSpriteNode?
    let BUTTONYPOSITION: CGFloat = (screenSize!.height / 20)
    
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
        //loadBlankBlob(scene: self)
        
        var reset_button = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("bttn_retry"))
        var lvls_button = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("bttn_levels"))
        //initButtons(reset_button: reset_button, lvls_button: lvls_button)
        self.swipeManager =  SwipeManager(scene: self, reset_button: reset_button, lvls_button: lvls_button)
        
        //fade out menu music, since always come here from menu
        AudioManager._audioInstance.fadeOut(player: AudioManager._audioInstance.playerMenu!)
        AudioManager._audioInstance.fadeInBackgroundAudio(player: AudioManager._audioInstance.playerPlay!)
    }
    
    deinit {
        print("PLAYSCENE DEINIT CALLED")
        //check if level has been cleared and main music has stopped playing already
        if AudioManager._audioInstance.playerPlay?.isPlaying == false {
            AudioManager._audioInstance.fadeOut(player: AudioManager._audioInstance.playerPlay!)
        }
        //start menu music
        AudioManager._audioInstance.fadeInBackgroundAudio(player: AudioManager._audioInstance.playerMenu!)
    }
    
    func initButtons(reset_button: SKSpriteNode, lvls_button: SKSpriteNode){
        //play scene
        
        //levelsScene = LevelsScene(size: screenSize!.size)
        
        addChild(reset_button)
        addChild(lvls_button)
        
        reset_button.position = CGPoint(x: (screenSize!.width / 6 * 4) - ((reset_button.size.width) / 2) , y: BUTTONYPOSITION)
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.allGoalsComplete = true
        
        for goal in goals {
            if goal.b_solved {
                if(goal.alpha < MAXALPHA - ALPHACHANGEAMOUNT){
                    goal.alpha += ALPHACHANGEAMOUNT
                }
            }
            if !goal.b_solved {
                if(goal.alpha > MINALPHA){
                    goal.alpha -= ALPHACHANGEAMOUNT
                }
                self.allGoalsComplete = false
            }
        }
        if self.allGoalsComplete {
            //_levelComplete()
        }
    }
    
    func drawDashedGrid(){
        for index in 0...8 {
            spriteRows[index].removeAllChildren()
            spriteRows[index].removeFromParent()
            spriteColumns[index].removeAllChildren()
            spriteColumns[index].removeFromParent()
            addChild(spriteRows[index])
            addChild(spriteColumns[index])
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
        print("PLAY SCENE WAS RESET")
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED * 2)
        playScene = nil
        playScene = PlayScene(size: self.size)
        playScene!.setLevel(level: self.level!)
        self.view?.presentScene(playScene!, transition: fade)
    }
    
    func _toLevels(){
        print("GOING TO LEVELS")
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //TODO, choose which page to go to based on the level modulo 9
        levelsScene = nil
        levelsScene = LevelsScene(size: self.size)
        levelsScene!.setPage(currentPage: GameViewController.initCurrentPageFromLocalStorage())
        self.view?.presentScene(levelsScene!, transition: fade)
    }
    
    override func didMove(to view: SKView){
        swipeManager!.handleSwipe(view: view)
    }
    
    func setLevel(level: Level){
        self.level = level
        //loadGoals()
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

