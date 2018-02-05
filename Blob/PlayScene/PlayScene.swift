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
    
   
    lazy var swipeManager: SwipeManager = SwipeManager(scene: self)
    
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        loadPlayScene(scene: self)
        loadBlankBlob(scene: self)
    }
    
    
    override func didMove(to view: SKView){
        swipeManager.handleSwipe(view: view)
    }
    
    func setLevel(level: Level){
        self.level = level
    }
    
    func loadPlayScene(scene: PlayScene){
        //print("LOADING PLAY SCENE OBJS")
        
        //load full size blank blob
    }
    
    func loadBlankBlob(scene: SKScene){
        self.blobs.append(Blob(x: 1, y: 1, width: 8, height: 8, shade: 0, scene: self))
    }
    
}
