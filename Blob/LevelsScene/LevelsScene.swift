//
//  MenuScene.swift
//  Blob
//
//  Created by shunkagaya on 28/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

let LEVELS_PER_PAGE = 9

class LevelsScene: SKScene {
    
    //array of all of the pages
    var currentPage: Int = 0 //[LevelSelectPage]()
    //lazy var swipeManager: LevelsSwipeManager = LevelsSwipeManager(scene: self)
    var swipeManager: LevelsSwipeManager?
    //let back_button: SKSpriteNode = SKSpriteNode(imageNamed: "bttn_play")
    var levelSprites = Array<LevelSprite>()
    //miniLevel = a small rectangular level
    //grid size is a tenth of the game grid size
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    override init(size: CGSize){
        
        super.init(size: size)
        self.swipeManager = LevelsSwipeManager(scene: self)
        //use default anchorPoint and draw everything from the middle!!!
        anchorPoint = CGPoint(x: 0.0, y: 0.0)
        //self.scaleMode = .aspectFill
        //self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        //set yScale to -1 to render oppositely from top left instead of bottom left like OpenGL style...
        //self.yScale = -1.0
        
        //back_button.posByScreen(x: 0.1, y: 0.1)
        //back_button.position = CGPoint(x: 0.2, y: 0.2)
        //removing the back button
        //scene?.addChild(back_button)
//        if(AudioManager._audioInstance.playerMenu?.isPlaying == false){
//            AudioManager._audioInstance.fadeInBackgroundAudio(player: AudioManager._audioInstance.playerMenu!)
//        }
    }
    
    deinit {
        print("DEINIT LEVELSSCENE CALLED")
        for levelSprite in levelSprites {
            levelSprite.removeAllChildren()
            levelSprite.removeAllActions()
            levelSprite.removeFromParent()
        }
        self.swipeManager = nil
        self.removeAllChildren()
        
    }
    // This is a duplicate... let me just find what it's a duplicate of... – nhgrif Jun 5 '15 at 23:24
    //possible duplicate of So if string is not NilLiteralConvertible... what do some string functions return? – nhgrif
    
    func setPage(currentPage: Int){
        self.currentPage = currentPage
        print("LOADING CURRENT PAGE AS: ", currentPage)
        loadLevelsScene()
        self.backgroundColor = setBackgroundColor()
    }
    
    //TODO finalize colors
    func setBackgroundColor() -> UIColor {
        switch(self.currentPage){
            case 1 : return UIColor.green
            case 2 : return UIColor.blue
            case 3: return UIColor.red
            case 4 : return UIColor.black
            default : return BACKGROUNDCOLOUR
        }
    }
    
    func loadLevelsScene(){
        //create 5 pages of 2d arrays
        //var level = LEVELS_PER_PAGE;
        
        //let totalPages = calculateTotalPages()
        var level = (9 * currentPage) + 1
        for page in 1...1{ //make this add pages from 1 to 1 for now...
            //var p: LevelSelectPage = LevelSelectPage(number: page, color: UIColor.green)
            
            for row in 0...2 {
                //for column in stride(from: 2, through: 0, by: -1){
                for column in 0...2{
                    //print("adding sprite at row: \(row), column: \(column)")
                    var miniLevel: MiniLevel = MiniLevel(x: CGFloat(column), y: CGFloat(row), level: level, levelsScene: self)
                    self.addChild(miniLevel.sprite)
                    levelSprites.append(miniLevel.sprite as! LevelSprite)
                    //print("adding label  at: \(row), \(column)")
                    //miniLevel.sprite.addChild(miniLevel.label)
                    //p.levels.append(miniLevel)
                    //level -= 1
                    level += 1
                }
            }
            //pages.append(p)
        }
    }
    //can check position with either self.nodes [skNodes], or by looping through levelSprites
    func checkTouch(touchPoint: CGPoint) {
        if gamestate == GAMESTATE.LEVELS {
            //let skNodes = self.nodes(at: touchPoint)
            //print("sknodes.length: ", skNodes.count)
            //print("touchPoint is: ", touchPoint)
            for levelSprite in levelSprites {
                
                //for skNode in skNodes {
                    //skNode.position.y = screenSize!.height - skNode.position.y
//                    levelSprite.position = CGPoint(
//                        x: levelSprite.xOffset,
//                        y: screenSize!.height - (levelSprite.yOffset)
//                    )
                //doesn't detect collision because fo coordinate difference AGAIN
                    //if skNode.intersects(<#T##node: SKNode##SKNode#>)
                
                    //print("skNode is: ", skNode)
                    //print("levelSprite: ", levelSprite)
                var invertedTouchPoint = CGPoint(x: touchPoint.x, y: screenSize!.height - touchPoint.y)
                if levelSprite.contains(invertedTouchPoint){
                    //if skNode.name == "levelSprite" {
                    if !levelSprite.locked {
                        _getPlayLevel(level: levelSprite.level)
                    }
                    //}
                }
            }
        }
    }
    //positions are colliding, but positions are set only as offsets
    //same name as function below, but takes in an Int, not a Level...wow, overloading so riskily
    func _getPlayLevel(level: Int){
        //load the touched level
        var lvlTitle = json4Swift_Base?.getLevelTitle(lvlNo: level)
        var lvlNo = json4Swift_Base?.getLevelNo(lvlNo: level)
        var lvlGoals: Array<Goals> = (Json4Swift_Base.getLevelGoals(lvlNo: level))
        
        //create a level
        var t_level = Level(lvlNo: lvlNo!, lvlTitle: lvlTitle!, goals: lvlGoals)
        self._goToPlayScene(level: t_level)
        //self.removeAllChildren()
    }
    
    func _goToPlayScene(level: Level){
        var fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //playScene = nil
        //playScene = PlayScene(size: self.size)
        playScene!.setLevel(level: level)
        //TODO save the currentPage to localStorage
        self.view?.presentScene(playScene!, transition: fade)
        emptyLevelSprites()
    }
    
    override func didMove(to view: SKView){
        swipeManager!.handleSwipe(view: view)
        gamestate = GAMESTATE.LEVELS
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            //let location = touch.location(in: self)
            
//            if back_button.contains(location){
//                print ("back button touched")
//                _toMenu()
//            }
        }
    }
    
    func _toMenu(){
        var fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //gameScene = nil
        //gameScene = GameScene(size: self.size)
        //gamestate = GAMESTATE.MENU
        self.view?.presentScene(gameScene!, transition: fade)
        emptyLevelSprites()
        
        
    }
    
    func preloadPlayScene(){
        var qualityOfServiceClass = DispatchQoS.QoSClass.background
        var backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            playScene = nil
            playScene = PlayScene(size: self.size)
            //print("PLAY SCENE LOADED")
            gameScene = GameScene(size: self.size)
            
            //self.preloadAdjacentLevelPages()
        })
    }
    
    func emptyLevelSprites(){
        var delay = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: delay){
            if(gamestate == GAMESTATE.PLAYING){
                for levelSprite in (levelsScene?.levelSprites)! {
                    levelSprite.removeAllChildren()
                    levelSprite.removeFromParent()
                }
                levelsScene?.levelSprites.removeAll()
                levelsScene?.removeAllChildren()
                self.removeFromParent()
                self.removeAllChildren()
                print("EMPTIED LEVELSPRITES")
            }
        }
    }
    
    //Deprecated, no necessary
//    func preloadAdjacentLevelPages(){
//        print("LOADING ADJACENT LEVELS")
//        if self.currentPage == 0 {
//            //load the scene on the right only
//            rightPage = LevelsScene(size: screenSize!.size)
//            rightPage!.setPage(currentPage: self.currentPage + 1)
//        }
//        else if self.currentPage == ((Json4Swift_Base.levels?.count)! / 9) - 1 {
//            //load only the left scene
//            leftPage = LevelsScene(size: screenSize!.size)
//            leftPage!.setPage(currentPage: self.currentPage - 1)
//        }
//        else {
//            //load both adjacent scenes
//            leftPage = LevelsScene(size: screenSize!.size)
//            leftPage!.setPage(currentPage: self.currentPage - 1)
//
//            rightPage = LevelsScene(size: screenSize!.size)
//            rightPage!.setPage(currentPage: self.currentPage + 1)
//        }
//
//        //attempting method of loading all levels
////        var totalLvls = Json4Swift_Base.levels?.count
////        var totalPages = totalLvls! / 9
////        for i in 1...totalPages {
////            //load LevelsScene
////        }
//    }
    
    func increasePage(){
        _changePage(toPage: self.currentPage + 1)
    }
    func decreasePage(){
        _changePage(toPage: self.currentPage - 1)
    }
    
    private func _changePage(toPage: Int){
        print("GOING TO PAGE: ", toPage)
        print("CURRENT PAGE IS: ", self.currentPage)
        var totalLvls = Json4Swift_Base.levels?.count
        //9 levels per page
        var _ = totalLvls! % 9
        var totalPages = totalLvls! / 9
        
        if(toPage < totalPages && toPage > -1){
            var transitionDirection: SKTransitionDirection?
            
            if(toPage > self.currentPage) {
                transitionDirection = SKTransitionDirection.left
                //rightPage!.preloadAdjacentLevelPages()
            }
            else if(toPage < self.currentPage){
                transitionDirection = SKTransitionDirection.right
                //leftPage!.preloadAdjacentLevelPages()
            }
            var nextPage = LevelsScene(size: screenSize!.size)
            nextPage.setPage(currentPage: toPage)
            currentPage = toPage
            var fade = SKTransition.push(with: transitionDirection!, duration: TRANSITIONSPEED / 2)
            self.view?.presentScene(nextPage, transition: fade)
            
            emptyLevelSprites()
            
        }
    }
}

