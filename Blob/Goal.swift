//
//  Goal.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

import SpriteKit

class Goal: SKSpriteNode {
    
    var start, length: Int?
    var label = SKLabelNode()
    var sprite = SKSpriteNode()
    var targetDirection: Goals.DIRECTION?
    var targetShade: Int?

    init(targetDirection: Goals.DIRECTION, start: Int, length: Int, targetShade: Int, scene: SKScene){
        super.init(
            texture: createGoalTexture(scene: scene,
                                       targetDirection: targetDirection,
                                       start: start,
                                       length: length,
                                       shade: targetShade),
            color: UIColor.black,
            size: CGSize(width: screenSize!.width, height: screenSize!.height)
        )
        
        self.targetDirection = targetDirection
        self.start = start
        self.length = length
        self.targetShade = targetShade
        self.anchorPoint = CGPoint(x: 0, y: 0)
        //self.zPosition = 2
        
        //self.sprite = SKSpriteNode(texture: self.texture.unsafelyUnwrapped)
        //scene.addChild(self.sprite)
//        self.size = CGSize(
//            x: self.texture?.textureRect().maxX - self.texture?.textureRect().minX,
//            y: self.texture?.textureRect().maxY - self.texture?.textureRect().minY
//        )
        self.position = CGPoint(
//            x: PLAYGRIDSIZE! * 9, y: PLAYGRIDSIZE! * 1
            x: 0, y: 0
        )
        initGoalLabel()
        scene.addChild(self)
        print("goal created: ",self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGoalLabel() {
        let label = SKLabelNode()
        label.text = String(describing: self.targetShade)
        label.fontSize = 32
        label.fontColor = SKColor.white
        label.zPosition = 1
        //label.position = CGPoint(x: 50, y: 50)
        self.addChild(label)
        print("GOAL LABEL IS: ", label)
        
        
    }
    
    func createGoalRect(targetDirection: Goals.DIRECTION, start: Int, length: Int) -> CGRect {
        switch targetDirection {
            case Goals.DIRECTION.TOP:
                print("CREATING GOAL FACING TOP")
                return CGRect(
                    x: CGFloat(start) * PLAYGRIDSIZE!,
                    y: 9 * PLAYGRIDSIZE!,
                    width: CGFloat(length) * PLAYGRIDSIZE!,
                    height: 1 * PLAYGRIDSIZE!
                )
                
            case Goals.DIRECTION.BOTTOM :
                print("CREATING GOAL FACING DOWN")
                return CGRect(
                    x: CGFloat(start) * PLAYGRIDSIZE!,
                    y: 0,
                    width: CGFloat(length) * PLAYGRIDSIZE!,
                    height: 1 * PLAYGRIDSIZE!
                )
            
            case Goals.DIRECTION.LEFT:
                print("CREATING GOAL FACING LEFT")
                return CGRect(
                    x: 9 * PLAYGRIDSIZE!,
                    y: CGFloat(start) * PLAYGRIDSIZE! + PLAYGRIDY0!,
                    width: PLAYGRIDSIZE!,
                    height: CGFloat(length) * PLAYGRIDSIZE!
                    //x: 0, y: 0, width: 1 * PLAYGRIDSIZE!, height: 1 * PLAYGRIDSIZE!
                    //736 - ((PLAYGRIDSIZE! * 1) + PLAYGRIDY0!)
                )
            
            case Goals.DIRECTION.RIGHT :
                print("CREATING GOAL FACING RIGHT")
                return CGRect(
                    x: 0,
                    y: CGFloat(start) * PLAYGRIDSIZE!,
                    width: 1 * PLAYGRIDSIZE!,
                    height: CGFloat(length) * PLAYGRIDSIZE!
                )
        }
    }
    
    func createGoalTexture(scene: SKScene, targetDirection: Goals.DIRECTION, start: Int, length: Int, shade: Int) -> SKTexture{
        //not using SKShadeNode due to memory leaks, using a drwing context with curve and converting it to a SKSpriteNode
        UIGraphicsBeginImageContext(CGSize(width: screenSize!.width, height: screenSize!.height))
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        ctx.saveGState()
        
        
        let goal = createGoalRect(targetDirection: targetDirection, start: start, length: length)
        print("GOAL RECT IS: ", goal)
        let clipPath: CGPath = UIBezierPath(roundedRect: goal, cornerRadius: 8).cgPath
        ctx.addPath(clipPath)
        
        let color = UIColor(rgb: ColourScheme.getColour(cut: shade)).cgColor
        
        ctx.setFillColor(color)
        
        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
        
        let goalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: goalImage!)
        
    }
}
