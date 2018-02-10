//
//  Blob.swift
//  Blob
//
//  Created by shunkagaya on 18/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import SpriteKit

class Blob {
    weak var blobSprite: SKSpriteNode?
    weak var label: SKLabelNode?
    var width, height, x, y: CGFloat
    var shade: Int
    var scene: SKScene?
    var gridX, gridY, gridWidth, gridHeight: Int
    var blobRect: CGRect?
    var DEFAULTGRIDSIZE: CGFloat
    var MARGINBETWEENBLOBS: CGFloat
    
    init(x: Int, y: Int, width: Int, height: Int, shade: Int, scene: SKScene, isMiniLevel: Bool ){
        self.gridX = x
        self.gridY = y
        self.gridWidth = width
        self.gridHeight = height
        //was facing a bug when initializing the below with a function, so have to use ternary statement instead
        self.DEFAULTGRIDSIZE = isMiniLevel ? MINILEVELGRIDSIZE! : PLAYGRIDSIZE!
        self.MARGINBETWEENBLOBS = DEFAULTGRIDSIZE / 15
        self.x = (CGFloat(x) * DEFAULTGRIDSIZE) + self.MARGINBETWEENBLOBS
        self.y = (CGFloat(y) * DEFAULTGRIDSIZE + PLAYGRIDY0!) + self.MARGINBETWEENBLOBS
        self.width = (CGFloat(width) * DEFAULTGRIDSIZE) - self.MARGINBETWEENBLOBS
        self.height = (CGFloat(height) * DEFAULTGRIDSIZE) - self.MARGINBETWEENBLOBS
        self.shade = shade
        self.scene = scene
        self.blobSprite = createRoundedRectSprite(scene: self.scene!)
        self.label = createBlobLabel(scene: self.scene!)
        self.blobSprite?.zPosition = 1
    }
    
    func createRoundedRectSprite(scene: SKScene) -> SKSpriteNode{
        //not using SKShadeNode due to memory leaks, using a drawing context with curve and converting it to a SKSpriteNode
        UIGraphicsBeginImageContext(scene.size)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        self.blobRect = CGRect(x: self.x, y: self.y, width: self.width, height: self.height) //multiplying height by -1 makes an interesting concave curve
        let clipPath: CGPath = UIBezierPath(roundedRect: self.blobRect!, cornerRadius: 20).cgPath
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
        blobSprite.anchorPoint = CGPoint(x: 0, y: 0)
        //print("BLOBSPRITE IS: ", blobSprite)
        scene.addChild(blobSprite)
        
        
        UIGraphicsEndImageContext()
        
        return blobSprite
    }
    
    func createBlobLabel(scene: SKScene) -> SKLabelNode {
        let label = SKLabelNode()
        label.text = String(self.shade)
        label.fontSize = 32
        label.fontColor = SKColor.black
        label.zPosition = 3
        label.fontName = CUSTOMFONT.fontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        //label.position = findCenterOfBlob()
        //label.position = CGPoint(x: self.x, y: self.y)
        //label.position.x += screenSize!.width / 15
        //label.position.y -= screenSize!.height / 10f
        
        let cgRect = self.blobRect!
        //CGPoint coordinates are from bottom left, so screenheight - y is neccessary
        label.position = CGPoint(x: cgRect.origin.x + cgRect.width / 2, y:  screenSize!.height - cgRect.origin.y - cgRect.height / 2)
        
        self.blobSprite!.addChild(label)
        //print("LABEL IS: ", label)
        
        return label
    }
    
    func drop() {
        
        let blobWidth = self.gridWidth // - 1 for the last open space // + 1 for the start at 1
        //print("blobWidth is: ", blobWidth)
        for tX in 1...blobWidth {
            let tPoint = defineBeneath(x: tX)
            if !checkBeneath(tPoint: tPoint){
                print("not dropping blob")
                return
            }
        }
        print("dropping blob")
        dropBlob()
    }
    
    func defineBeneath(x: Int) -> CGPoint {
        return CGPoint(
            x: (CGFloat(x) * PLAYGRIDSIZE!) + PLAYGRIDSIZE! / 2,
            y: (self.y + self.height) + PLAYGRIDSIZE! / 2
        )
    }
    
    func checkBeneath(tPoint: CGPoint) -> Bool {
        for blob in (self.scene! as? PlayScene)!.blobs{
            if (blob.gridY + self.gridHeight == 9) {
                //print("a blob is sitting at bottom of play grid")
                //no action, skip this blob
                continue
            }
            else if blob.blobRect!.contains(tPoint) {
                //let blobRect = CGRect(x: blob.x, y: blob.y, width: blob.width, height: blob.height)
                //blob.bl
                
                print("a blob contains coordinate beneath another blob")
                
                //debug conditional
                if self.shade == 2 {
                    print("2 is colliding with blob: ", blob)
                    //print("colliding blob.position is: ", blob.blobSprite?.position)
                }
                
                return false
            }
        }
        return true
    }
    
    func dropBlob(){
        if self.gridY + self.gridHeight < 9 {
            print("Blob is physically dropping")
            //using CGContext...changing x and y does not change sprite position...they are not locked in together, it's only on instantiation...therefore, need to change position, as an offset...
            //how many hours of struggle, all because I chose to use CGContext...
            
            //make the changes "on paper"
            self.y += PLAYGRIDSIZE!
            //draw out the actual changes
            self.blobSprite?.position.y -= PLAYGRIDSIZE!
            
            //check all blobs drop again
            //drop()
            
            //different blob drops when another one is sliced...need to debug it yo
        }
    }
    
}


