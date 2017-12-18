//
//  LevelSprite.swift
//  Blob
//
//  Created by shunkagaya on 18/12/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class LevelSprite : SKSpriteNode {
    
    var level: Int = 0
    
    //convenience init(level: Int ){
    init(level: Int){
        //have to call this initializer,t he other are al convenience initializers
        super.init(texture: nil, color: UIColor.black, size: CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!))
        self.level = level
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //self.level = 0
        //super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("level: \(self.level) was touched")
    }
}
