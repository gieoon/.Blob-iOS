//
//  GameScene.swift
//  Blob
//
//  Created by shunkagaya on 15/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var BUTTONYPOS: CGFloat = -0.2
    var play_button, settings_button, help_button, gameBorder1, gameBorder2, title_banner: SKSpriteNode?
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.55)

        //self.scaleMode = .aspectFill//.aspectFit//.resizeFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        loadHomeScreen(scene: self)
        loadButtons()
        
    }
    
//    override func willMoveFromView(){
//
//    }
    
    deinit {
        print("Deinit MENU SCENE")
//        gameBorder1!.removeFromParent()
//        gameBorder2!.removeFromParent()
//        settings_button!.removeFromParent()
//        play_button!.removeFromParent()
//        help_button!.removeFromParent()
//        title_banner!.removeFromParent()
//        self.removeAllChildren()
//        self.removeAllActions()
//        scene?.removeAllChildren()
    }
    func loadButtons(){
//        title_banner!.removeFromParent()
//        self.scene!.addChild(title_banner!)
//        gameScene?.addChild(gameBorder1!)
//        gameScene?.addChild(gameBorder2!)
//        gameScene?.addChild(play_button!)
//        gameScene?.addChild(settings_button!)
//        gameScene?.addChild(help_button!)
    }
    
    func loadHomeScreen(scene: GameScene){
        //title banner
        //title_banner.position = CGPoint()
        self.play_button = SKSpriteNode(texture: Assets._sharedInstance.textureAtlas.textureNamed("bttn_play"))
        
        self.settings_button = SKSpriteNode(texture: Assets.sharedInstance.textureAtlas.textureNamed("bttn_settings"))
        
        self.help_button = SKSpriteNode(texture: Assets.sharedInstance.textureAtlas.textureNamed("bttn_help"))
        
        self.gameBorder1 = SKSpriteNode(texture: Assets.sharedInstance.textureAtlas.textureNamed("game_border"))
        
        self.gameBorder2 = self.gameBorder1!.copy() as? SKSpriteNode
        
        self.title_banner = SKSpriteNode(texture: Assets.sharedInstance.textureAtlas.textureNamed("blob_banner"))
        title_banner!.posByScreen(x: 0, y: 0)
        title_banner!.resizeByScreen(x: 0.83, y: 0.18)
        
        addChild(title_banner!)
        //LOL
        #imageLiteral(resourceName: "game_border")
        //LOL
        gameBorder1!.anchorPoint = CGPoint(x: 0, y: 0)
        gameBorder1!.position = CGPoint(x: 0, y: 0)
        gameBorder1!.resizeByScreen(x: 1, y: 0.06)
        gameBorder1!.posByScreen(x: -0.5, y: 0.39)
        addChild(gameBorder1!)
        
        gameBorder2?.anchorPoint = CGPoint(x: 0, y: 0)
        gameBorder2?.position = CGPoint(x: 0, y: 0)
        gameBorder2?.resizeByScreen(x: 1, y: 0.06)
        gameBorder2?.posByScreen(x: -0.5, y: -0.55)
        addChild(gameBorder2!)
        //game
        //game?
        //play button
        //var play_button: SKNode! = nil
        //play_button.position =
        //play_button.anchorPoint = CGPoint(x: 0.5, y: 0.75)
        
        play_button!.posByScreen(x: -0.19, y: BUTTONYPOS)
        play_button!.name = "play_button"
        play_button!.zPosition = 1.0
        play_button!.isUserInteractionEnabled = false
        play_button!.resizeByScreen(x: BUTTON_WIDTH_SCALE, y: BUTTON_HEIGHT_SCALE)
        addChild(play_button!)
        
        //settings button
        settings_button?.posByScreen(x: 0, y: BUTTONYPOS)
        settings_button?.resizeByScreen(x: BUTTON_WIDTH_SCALE, y: BUTTON_HEIGHT_SCALE)
        addChild(settings_button!)
        //help - credits button
        help_button?.posByScreen(x: 0.19, y: BUTTONYPOS)
        help_button?.resizeByScreen(x: BUTTON_WIDTH_SCALE, y: BUTTON_HEIGHT_SCALE)
        addChild(help_button!)
        print("HELP BUTTON: ", help_button)
        print("Loaded GameScene")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if play_button!.contains(location){
                //print ("play button touched")
                _toLevels()
            }
            else if settings_button!.contains(location){
                print("settings button touched")
            }
            else if help_button!.contains(location){
                print("help button touched")
            }
        }
        
        
        // let location = touches.anyObject()?.locationInNode(self)
        
//        if let touch = touches.first {
//            //let location = touch.location(self)
//            let node = nodeAtPoint(touch.location(event))
//
//        }
    }
    
    
    func _toLevels(){
        //let reveal = SKTransition.crossFade(withDuration: TRANSITIONSPEED)
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //TODO, choose which page to go to based on the level modulo 9
        levelsScene = nil
        levelsScene = LevelsScene(size: screenSize!.size)
        levelsScene!.setPage(currentPage: GameViewController.initCurrentPageFromLocalStorage())
        self.view?.presentScene(levelsScene!, transition: fade)
    }
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
//    override func didMove(to view: SKView) {
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
    //? means it is an optionl value whic can contain a value, or nothing at all.
    //nil = null
    
//    public func setupScene() -> SKScene {
//        let scene = SKScene(size: CGSize(width: 1024, height: 768))
//        scene.scaleMode = .aspectFit
//        scene.backgroundColor = SKColor.green
//        return scene
//    }
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
