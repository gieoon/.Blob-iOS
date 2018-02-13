//
//  LoadingScene.swift
//  Blob
//
//  Created by gieoon on 2018/02/11.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

import Foundation
//
//  GameScene.swift
//  Blob
//
//  Created by shunkagaya on 15/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class LoadingScene: SKScene {
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        //preloadTextures()
        //gamestate = GAMESTATE.LOADING
        
        //self.scaleMode = .aspectFill//.aspectFit//.resizeFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        //var count = 1
        //while(gamestate == GAMESTATE.LOADING){
            //WAIT HERE
            //print("Loading: ", count)
            //count += 1
        //}
        //print("STARTING GAME WITH COUNT OF: ", count)
        _startGame()
    }
    
    func preloadTextures(){
        Assets._sharedInstance.preloadAssets()
        
//        textureAtlas = SKTextureAtlas(named: "assetsAtlas")
//        textureAtlas?.preload {
//
//        }
    }
    
    deinit {
        print("Deinit LOADING SCENE")
//        self.removeAllChildren()
//        self.removeAllActions()
//        scene?.removeAllChildren()
//        scene?.removeFromParent()
    }
    
    func _startGame(){
        //let reveal = SKTransition.crossFade(withDuration: TRANSITIONSPEED)
        let fade = SKTransition.fade(with: BACKGROUNDCOLOUR, duration: TRANSITIONSPEED)
        //TODO, choose which page to go to based on the level modulo 9
        
        gameScene = GameScene(size: screenSize!.size)
        //levelsScene = LevelsScene(size: screenSize!.size)
        //levelsScene?.setPage(currentPage: 0)
        LoadingOverlay.shared.hideOverlayView()
        gamestate = GAMESTATE.MENU
        self.view?.presentScene(gameScene!, transition: fade)
    }
}

class Assets {
    static let _sharedInstance = Assets()
    static var progressValue: CGFloat = 0.0
    static var progressSprite: SKSpriteNode?
    //creates textureAtlas from data stored in app bundle
    let textureAtlas = SKTextureAtlas(named: "assetsAtlas") //(named: "assetsAtlas").preload {}
    
    func increaseProgressValue(){
        let TOTALASSETS: CGFloat = 9.0
        let stepSize = screenSize!.height / TOTALASSETS
        //Assets.progressValue += stepSize
        //Assets.progressSprite?.size.height = Assets.progressValue
    }
    static func createProgressBar() -> SKSpriteNode {
        let sk = SKSpriteNode(color: UIColor(rgb: 0xD0C69B), size: CGSize(width: screenSize!.width, height: Assets.progressValue))
        sk.anchorPoint = CGPoint(x: 0, y: 0)
        return sk
    }
    
    func preloadAssets(){
//        textureAtlas.preload {
//            //Assets.progressSprite = Assets.createProgressBar()
//            // Now everything you put into the texture atlas has been loaded in memory
////            self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue();self.increaseProgressValue()
//            //print("gamestate is: ", gamestate)
//            gamestate = GAMESTATE.MENU
//            //addChild(Assets.progressSprite!)
//
//            print("ALL TEXTURES PRELOADED!!")
//
//        }
        
    }
    
    //if let hoodDescription = hooddesc.text where hoodDescription  != "" , let img = addHoodImg.image {}
    func loadJSONFromFile(){
        //var goals = [Goal]()
        //var levels = [Level]()
        do{
            typealias JSONDictionary = [String: Any]
            //have to include the .json file in build phases resources
            var jsonFile = Bundle.main.path(forResource: "levels", ofType: "json")
            var jsonData = NSData(contentsOfFile: jsonFile!)
            var jsonDictionary: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: []) as! NSDictionary
            
            //let data: Data
            //let json = try?
            //   JSONSerialization.jsonObject(with: data) as? [String : Any],
            //let goal = json["levels"] as? [String: Any]
            //guard //<-- Error //syntax for "throws"
            
            
            if jsonDictionary as? [String: Any] != nil{
                
                json4Swift_Base = Json4Swift_Base(dictionary: jsonDictionary)
                //print("JSON4SWIFT BASE: ", json4Swift_Base as Any)
                
                //let lvlNo = json4Swift_Base?.levels![5].lvlNum
                //print("LVLNO IS: ", lvlNo)
            }
            //            else if let object = jsonDictionary as? [Any]{
            //                print("OBJECT IS AN ARRAY: ", object)
            //            }
            //            else {
            //                print("JSON IS INVALID")
            //            }
            //let goal = jsonString["levels"] as? [String: Any]
            
            //print("JSONSTRING IS: ", jsonString)
            //print ("LEVELS IS: ", goal)
            
        }
    }
    
    class var sharedInstance : Assets {
        return _sharedInstance
    }
}
