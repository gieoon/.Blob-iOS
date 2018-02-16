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
    var extraPlayScene: PlayScene?
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    
    override init(size: CGSize){
        super.init(size: size)
        //anchorPoint = CGPoint(x: 0.5, y: 0.55)
        //self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        
        var reset_button = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("bttn_retry"))
        var lvls_button = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("bttn_levels"))
        var dashedGrid = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("dashedSprite"))
        initButtons(reset_button: reset_button, lvls_button: lvls_button, dashedSprite: dashedGrid)
        self.swipeManager =  SwipeManager(scene: self, reset_button: reset_button, lvls_button: lvls_button)
        
        loadBlankBlob(scene: self)
        
        
    }
    
    deinit {
        print("PLAYSCENE DEINIT CALLED")
        //check if level has been cleared and main music has stopped playing already
        if AudioManager._audioInstance.playerPlay?.isPlaying == false {
            AudioManager._audioInstance.fadeOut(player: AudioManager._audioInstance.playerPlay!)
        }
        //start menu music
        AudioManager._audioInstance.fadeInBackgroundAudio(player: AudioManager._audioInstance.playerMenu!)
        //emptyScene() //already done
    }
    
    func initButtons(reset_button: SKSpriteNode, lvls_button: SKSpriteNode, dashedSprite: SKSpriteNode){
        //play scene
        
        //levelsScene = LevelsScene(size: screenSize!.size)
        
        addChild(reset_button)
        addChild(lvls_button)
        
        var SCALEAMT: CGFloat = 1.05
        var H_SCALEAMT: CGFloat = 1.0155
        dashedSprite.anchorPoint = CGPoint(x: 0.505, y: 1)
        dashedSprite.size = CGSize(width: PLAYGRIDSIZE! * 9.5 * H_SCALEAMT, height: PLAYGRIDSIZE! * 9.5 * SCALEAMT)
        dashedSprite.position = CGPoint(x: screenSize!.width / 2, y: screenSize!.height - PLAYGRIDY0!)
        dashedSprite.zPosition = 0
        addChild(dashedSprite)
        
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
            _levelComplete()
        }
    }
    
    //Deprecated
//    func drawDashedGrid(){
//        for index in 0...8 {
//            spriteRows[index].removeAllChildren()
//            spriteRows[index].removeFromParent()
//            spriteColumns[index].removeAllChildren()
//            spriteColumns[index].removeFromParent()
//            addChild(spriteRows[index])
//            addChild(spriteColumns[index])
//        }
//    }
    
    override func willMove(from view: SKView) {
        //anytime this scene is exited, total slices is saved
        DataStorage._sharedInstance.dataToSave.totalSlices = totalSlices
        DataStorage._sharedInstance.saveData()
        print("PLAYSCENE WILLMOVE() CALLED AND SAVING TOTAL SLICES: ", totalSlices)
    }
    
    func _levelComplete(){
        //unlock the next level
        //write to JSON or local storage and unlock the next level
        DataStorage._sharedInstance.dataToSave.unlockedLvl = self.level!.lvlNo + 1
        DataStorage._sharedInstance.dataToSave.totalSlices = totalSlices
        //add next level to  unlocked levels array
        DataStorage._sharedInstance.saveData()
        //go back to menu screen
        _toLevels()
        gamestate = GAMESTATE.LEVELS
    }
    
    func resetPlayScene(){
        print("PLAY SCENE WAS RESET")
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED * 1.25)
        emptyScene()
        var tPlayScene = PlayScene(size: self.size)
        tPlayScene.setLevel(level: self.level!)
        //TODO save the currentPage to localStorage
        self.view?.presentScene(tPlayScene, transition: fade)
        playScene! = tPlayScene
        //replenish the global scene
        //playScene = self.extraPlayScene
    }
    
    func _toLevels(){
        print("GOING TO LEVELS")
        emptyScene()
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //TODO, choose which page to go to based on the level modulo 9
        levelsScene = nil
        levelsScene = LevelsScene(size: self.size)
        levelsScene!.setPage(currentPage: currentPage)
        self.view?.presentScene(levelsScene!, transition: fade)
        gamestate = GAMESTATE.LEVELS
        
    }
    
    func preloadScenes(){
        var timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            var qualityOfServiceClass = DispatchQoS.QoSClass.background
            var backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                levelsScene!.setPage(currentPage: DataStorage._sharedInstance.dataToSave.currentLevel! / 9)
                levelsScene!.preloadPlayScene()
                self.extraPlayScene = PlayScene(size: self.size)
                self.extraPlayScene!.setLevel(level: self.level!)
                print("PLAY SCENE LOADED")
            })
        }
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func emptyScene(){
        var delay = DispatchTime.now() + 6
        DispatchQueue.main.asyncAfter(deadline: delay) {
            for blob in self.blobs {
                blob.blobSprite?.removeAllChildren()
                blob.blobSprite?.removeFromParent()
                blob.blobRect = nil
                blob.label?.removeAllChildren()
                blob.label?.removeFromParent()
            }
            self.blobs.removeAll()
            for goal in self.goals {
                goal.removeFromParent()
            }
            self.inputGoals.removeAll()
            self.goals.removeAll()
            self.swipeManager = nil
            self.level = nil
            self.removeAllChildren()
            print("EMPTIED PLAYSCENE")
        }
        
    }
    
    override func didMove(to view: SKView){
        gamestate = GAMESTATE.PLAYING
        swipeManager!.handleSwipe(view: view)
        preloadScenes()
        
    }
    
    func setLevel(level: Level){
        self.level = level
        loadGoals()
        //can also put thsi in didMoveToView(){}
        if gamestate == GAMESTATE.PLAYING {
            //fade out menu music, since always come here from menu
            AudioManager._audioInstance.fadeOut(player: AudioManager._audioInstance.playerMenu!)
            AudioManager._audioInstance.fadeInBackgroundAudio(player: AudioManager._audioInstance.playerPlay!)
            
        }
    }
    
    
    func loadBlankBlob(scene: SKScene){
        var blob = Blob(x: 1, y: 1, width: 8, height: 8, shade: 0, scene: self, isMiniLevel: false)
        self.blobs.append(blob)
        //scene.addChild(blob.blobSprite!)
        //blob.blobSprite!.addChild(blob.label!)
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

