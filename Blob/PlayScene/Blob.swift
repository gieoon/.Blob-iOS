//
//  Blob.swift
//  Blob
//
//  Created by shunkagaya on 18/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class Blob {
    var blobSprite: SKSpriteNode?
    var label: SKLabelNode?
    var width, height, x, y: CGFloat
    var shade: Int
    var scene: SKScene?
    var gridX, gridY, gridWidth, gridHeight: Int
    
    init(x: Int, y: Int, width: Int, height: Int, shade: Int, scene: SKScene ){
        self.gridX = x
        self.gridY = y
        self.gridWidth = width
        self.gridHeight = height + self.gridY
        self.x = CGFloat(x) * PLAYGRIDSIZE!
        self.y = CGFloat(y) * PLAYGRIDSIZE! + PLAYGRIDY0!
        self.width = CGFloat(width) * PLAYGRIDSIZE!
        self.height = CGFloat(height) * PLAYGRIDSIZE!
        self.shade = shade
        self.scene = scene
        self.blobSprite = createRoundedRectSprite(scene: self.scene!)
        self.label = createBlobLabel(scene: self.scene!)
        self.blobSprite?.zPosition = 1
    }
    
    func createRoundedRectSprite(scene: SKScene) -> SKSpriteNode{
        //not using SKShadeNode due to memory leaks, using a drwing context with curve and converting it to a SKSpriteNode
        UIGraphicsBeginImageContext(scene.size)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let blob = CGRect(x: self.x, y: self.y, width: self.width, height: self.height) //multiplying height by -1 makes an interesting concave curve
        let clipPath: CGPath = UIBezierPath(roundedRect: blob, cornerRadius: 24).cgPath
        ctx.addPath(clipPath)
        
        let color = UIColor(rgb: ColourScheme.getColour(cut: self.shade)).cgColor

        ctx.setFillColor(color)
        
        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
        
        let blobImage = UIGraphicsGetImageFromCurrentImageContext()
        let blobTexture = SKTexture(image: blobImage!)
        let blobSprite = SKSpriteNode(texture: blobTexture)
        //blobSprite.position.x = 0//self.x //these positions are an offset to add. Not necessary here
        //blobSprite.position.y = 0//self.y
        //blobSprite.color = UIColor(rgb: self.shade)
        //blobSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //print("BLOBSPRITE IS: ", blobSprite)
        scene.addChild(blobSprite)
        
        UIGraphicsEndImageContext()
        
        return blobSprite
    }
    
    func createBlobLabel(scene: SKScene) -> SKLabelNode {
        let label = SKLabelNode()
        label.text = String(self.shade)
        label.fontSize = 32
        label.fontColor = SKColor.white
        //label.position = findCenterOfBlob()
        //label.position = CGPoint(x: self.x, y: self.y)
        //label.position.x += screenSize!.width / 15
        //label.position.y -= screenSize!.height / 10f
        self.blobSprite!.addChild(label)
        //print("LABEL IS: ", label)
        
        return label
    }
    
//    func findCenterOfBlob() -> CGPoint {
//        let halfX = (self.width / 2) + self.x
//        let halfY = ((self.height / 2) + self.y)//self.scene!.size.height -
//        return CGPoint(x: halfX, y: halfY)
//    }
}


