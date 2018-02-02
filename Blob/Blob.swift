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
    var width, height, x, y: CGFloat
    var shade: Int
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, shade: Int ){
        self.x = x
        self.y = y
        self.width = width * GRIDSIZE!
        self.height = height * GRIDSIZE!
        self.shade = shade
        createRoundedRect()
        print(self)
    }
    
    func createRoundedRect(){

        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let blob = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
        let clipPath: CGPath = UIBezierPath(roundedRect: blob, cornerRadius: 6).cgPath
        
        ctx.addPath(clipPath)
        let color = UIColor(rgb: self.shade).cgColor
        ctx.setFillColor(color)
        
        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
    }
    
}


