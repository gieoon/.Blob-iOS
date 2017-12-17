//
//  LevelSelectPage.swift
//  Blob
//
//  Created by shunkagaya on 02/12/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

//a structrue forming the page object, which hold all of the levels inside it
//has a sprite the size of the screen with a background color
struct LevelSelectPage {
    
    let number: Int
    let color: UIColor
    var levels: [MiniLevel]
    
    init(number: Int, color: UIColor){
        self.number = number
        self.color = color
        self.levels = [MiniLevel]()
    }
    
}
