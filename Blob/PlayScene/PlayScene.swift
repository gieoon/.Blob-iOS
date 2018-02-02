//
//  PlayScene.swift
//  Blob
//
//  Created by USER on 2018/02/02.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.55)
        self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        loadPlayScene(scene: self)
    }
    
    func loadPlayScene(scene: PlayScene){
        print("LOADING PLAY SCENE OBJS")
        
        //load full size blank blob
    }
    
}
