//
//  Blob.swift
//  Blob
//
//  Created by shunkagaya on 18/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class Blob {
    var sprite: SKSpriteNode?
    var width, height, x, y: Int
    
    init(x: Int, y: Int, width: Int, height: Int ){
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}
