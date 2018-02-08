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
    var pages = [LevelSelectPage]()
    
    let back_button: SKSpriteNode = SKSpriteNode(imageNamed: "bttn_play")
    //miniLevel = a small rectangular level
    //grid size is a tenth of the game grid size
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    override init(size: CGSize){
        super.init(size: size)
        //use default anchorPoint and draw everything from the middle!!!
        anchorPoint = CGPoint(x: 0.0, y: 0.0)
        //self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        //set yScale to -1 to render oppositely from top left instead of bottom left like OpenGL style...
        //self.yScale = -1.0
        loadLevelsScene()
        
        back_button.posByScreen(x: 0.1, y: 0.1)
        //back_button.position = CGPoint(x: 0.2, y: 0.2)
        scene?.addChild(back_button)
    }
    // This is a duplicate... let me just find what it's a duplicate of... – nhgrif Jun 5 '15 at 23:24
    //possible duplicate of So if string is not NilLiteralConvertible... what do some string functions return? – nhgrif
    
    func loadLevelsScene(){
        //create 5 pages of 2d arrays
        //var level = LEVELS_PER_PAGE;
        var level = 1
        for page in 1...1{ //make this add pages from 1 to 1 for now...
            var p: LevelSelectPage = LevelSelectPage(number: page, color: UIColor.green)
            
            for row in 0...2 {
                //for column in stride(from: 2, through: 0, by: -1){
                for column in 0...2{
                    //print("adding sprite at row: \(row), column: \(column)")
                    let miniLevel: MiniLevel = MiniLevel(x: CGFloat(column), y: CGFloat(row), level: level, levelsScene: self)
                    self.addChild(miniLevel.sprite)
                    //print("adding label  at: \(row), \(column)")
                    //miniLevel.sprite.addChild(miniLevel.label)
                    p.levels.append(miniLevel)
                    //level -= 1
                    level += 1
                }
            }
            pages.append(p)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            let location = touch.location(in: self)
            
            if back_button.contains(location){
                print ("back button touched")
                _toMenu()
            }
        }
    }
    
    func _toMenu(){
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        let menuScene = GameScene(size: self.size)
        self.view?.presentScene(menuScene, transition: fade)
    }
    
    
    func _goToPlayScene(level: Level){
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        let playScene = PlayScene(size: self.size)
        playScene.setLevel(level: level)
        self.view?.presentScene(playScene, transition: fade)
    }
}

