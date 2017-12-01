//
//  MenuScene.swift
//  Blob
//
//  Created by shunkagaya on 28/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class LevelsScene: SKScene {
    
    //array of all of the pages
    //var pages
    
    //miniLevel = a small rectangular level
    //grid size is a tenth of the game grid size
    
    override init(size: CGSize){
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFill
        self.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
        loadLevelsScene()
    }
    
    func loadLevelsScene(){
        //let
    }
}

