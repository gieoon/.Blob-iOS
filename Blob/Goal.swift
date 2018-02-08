//
//  Goal.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

import SpriteKit

class Goal: SKSpriteNode {
    
    var start, length: Int?
    var label: SKLabelNode?
    var sprite = SKSpriteNode()
    var targetDirection: Goals.DIRECTION?
    var targetShade: Int?
    var playScene: PlayScene?
    var levelsScene: LevelsScene?
    var cgRect: CGRect?
    var b_solved: Bool
    var DEFAULTGRIDSIZE: CGFloat
    var isMiniLevel: Bool

    init(targetDirection: Goals.DIRECTION, start: Int, length: Int, targetShade: Int, playScene: PlayScene?, levelsScene: LevelsScene?, isMiniLevel: Bool){
        self.playScene = playScene
        self.levelsScene = levelsScene
        self.isMiniLevel = isMiniLevel
        self.b_solved = false
        self.DEFAULTGRIDSIZE = isMiniLevel ? MINILEVELGRIDSIZE! : PLAYGRIDSIZE!
        super.init(
            texture: createGoalTexture(scene: getCurrentSceneType(),
                                       targetDirection: targetDirection,
                                       start: start,
                                       length: length,
                                       shade: targetShade),
            color: UIColor.black,
            size: CGSize(
                width: isMiniLevel ? PAGEGRIDSIZE! : screenSize!.width,
                height: isMiniLevel ? PAGEGRIDSIZE! : screenSize!.height)
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

        getCurrentSceneType().addChild(self)
        self.label = initGoalLabel()
        addChild(self.label!)
        
        //print("goal created: ",self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentSceneType() -> SKScene {
        if self.playScene == nil {
            return self.levelsScene!
        }
        else  { return self.playScene! }
    }
    
    func initGoalLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.text = String(self.targetShade!)
        label.fontSize = self.isMiniLevel ? 10 : 32
        label.fontColor = SKColor.black
        label.zPosition = 3
        label.fontName = CUSTOMFONT.fontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        self.cgRect = createGoalRect(targetDirection: self.targetDirection!, start: self.start!, length: self.length!)
        //CGPoint coordinates are from bottom left, so screenheight - y is neccessary
        label.position = CGPoint(x: self.cgRect!.origin.x + self.cgRect!.width / 2, y:  screenSize!.height - self.cgRect!.origin.y - self.cgRect!.height / 2)
        //cgRect.minY + cgRect.height + label.frame.height / 2
        //print("cgRect IS: ", cgRect)
        return label
    }
    
    func createGoalRect(targetDirection: Goals.DIRECTION, start: Int, length: Int) -> CGRect {
        switch targetDirection {
            case Goals.DIRECTION.TOP:
                //print("CREATING GOAL FACING TOP")
                
                return CGRect(
                    x: CGFloat(start) * DEFAULTGRIDSIZE,
                    y: 9 * DEFAULTGRIDSIZE + (self.isMiniLevel ? 0 : PLAYGRIDY0!),
                    width: CGFloat(length) * DEFAULTGRIDSIZE,
                    height: 1 * DEFAULTGRIDSIZE
                )
                
            case Goals.DIRECTION.BOTTOM :
                //print("CREATING GOAL FACING DOWN")
                return CGRect(
                    x: CGFloat(start) * DEFAULTGRIDSIZE,
                    y: (self.isMiniLevel ? 0 : PLAYGRIDY0!),
                    width: CGFloat(length) * DEFAULTGRIDSIZE,
                    height: 1 * DEFAULTGRIDSIZE
                )
            
            case Goals.DIRECTION.LEFT:
                //print("CREATING GOAL FACING LEFT")
                
                return CGRect(
                    x: 9 * DEFAULTGRIDSIZE,
                    y: CGFloat(start) * DEFAULTGRIDSIZE + (self.isMiniLevel ? 0 : PLAYGRIDY0!),
                    width: DEFAULTGRIDSIZE,
                    height: CGFloat(length) * DEFAULTGRIDSIZE
                )
            
            case Goals.DIRECTION.RIGHT :
                //print("CREATING GOAL FACING RIGHT")
                return CGRect(
                    x: 0,
                    y: CGFloat(start) * DEFAULTGRIDSIZE + (self.isMiniLevel ? 0 : PLAYGRIDY0!),
                    width: 1 * DEFAULTGRIDSIZE,
                    height: CGFloat(length) * DEFAULTGRIDSIZE
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
        //print("GOAL RECT IS: ", goal)
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
    
    //what gives this game some character
    func checkNearbyBlob() -> Bool {
        let checkPoint = defineAdjacent()
        for blob in (self.playScene?.blobs)! {
            if (blob.blobRect?.contains(checkPoint))!{
                if(blob.shade == self.targetShade!){
                    return checkAdjacentBlobSize(blob: blob)
                }
            }
        }
        return false
    }
    
    func defineAdjacent() -> CGPoint {
        switch(self.targetDirection!){
            case Goals.DIRECTION.TOP :
                return CGPoint(
                    x: self.cgRect!.origin.x + DEFAULTGRIDSIZE / 2,
                    y: self.cgRect!.origin.y - DEFAULTGRIDSIZE / 2
                )
            case Goals.DIRECTION.BOTTOM :
                return CGPoint(
                    x: self.cgRect!.origin.x + DEFAULTGRIDSIZE / 2,
                    y: self.cgRect!.origin.y + self.cgRect!.height + DEFAULTGRIDSIZE / 2
                )
            case Goals.DIRECTION.LEFT :
                return CGPoint(
                    x: self.cgRect!.origin.x - DEFAULTGRIDSIZE / 2,
                    y: self.cgRect!.origin.y + DEFAULTGRIDSIZE / 2
                )
            case Goals.DIRECTION.RIGHT :
                return CGPoint(
                    x: self.cgRect!.origin.x + self.cgRect!.width + DEFAULTGRIDSIZE / 2,
                    y: self.cgRect!.origin.y + DEFAULTGRIDSIZE / 2
                )
        }
    }
    
    func checkAdjacentBlobSize(blob: Blob) -> Bool {
        switch(self.targetDirection!){
            case Goals.DIRECTION.TOP, Goals.DIRECTION.BOTTOM :
                if (blob.blobRect?.width)! - self.cgRect!.width < DEFAULTGRIDSIZE / 4 {
                    print("GOAL IS COLLIDING")
                    self.b_solved = true
                    //TODO play solved sound
                    return true
                }
            case Goals.DIRECTION.LEFT, Goals.DIRECTION.RIGHT :
                if (blob.blobRect?.height)! - self.cgRect!.height < DEFAULTGRIDSIZE / 4 {
                    print("GOAL IS COLLIDING")
                    self.b_solved = true
                    //TODO play solved sound
                    return true
            }
        }
        //check if it has been solved and is now disabled
        if(self.b_solved){
            //play loss of goal sound
            print("GOAL IS NOT COLLIDING ANYMORE")
        }
        return false
    }
}
