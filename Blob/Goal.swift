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
    weak var sprite = SKSpriteNode()
    var targetDirection: Goals.DIRECTION?
    var targetShade: Int?
    var playScene: PlayScene?
    var levelsScene: LevelsScene?
    var cgRect: CGRect?
    var b_solved: Bool
    var DEFAULTGRIDSIZE: CGFloat
    var isMiniLevel: Bool
    var displayAlpha: CGFloat
    let GOALRADIUS: CGFloat = 8
    var goalStrokeSprite: SKSpriteNode?
    let MAXALPHA: CGFloat = 1.0 //adds 0.7
    let MINALPHA: CGFloat = 0.3
    let ALPHATRANSITIONSPEED: TimeInterval = 1.0
    let ALPHACHANGEAMOUNT: CGFloat = 0.15
    
    init(targetDirection: Goals.DIRECTION, start: Int, length: Int, targetShade: Int, playScene: PlayScene?, levelsScene: LevelsScene?, isMiniLevel: Bool){
        self.playScene = playScene
        self.levelsScene = levelsScene
        self.isMiniLevel = isMiniLevel
        self.b_solved = false
        self.displayAlpha = 1 //always init sprites with max alpha
        self.DEFAULTGRIDSIZE = isMiniLevel ? MINILEVELGRIDSIZE! : PLAYGRIDSIZE!
        super.init(
            texture: createGoalTexture(scene: getCurrentSceneType(),
                                       targetDirection: targetDirection,
                                       start: start,
                                       length: length,
                                       shade: targetShade),
            color: UIColor.black,
            size: CGSize(
                width: isMiniLevel ? (PAGEGRIDSIZE! - PAGEMARGINSIZE!) : screenSize!.width,
                height: isMiniLevel ? (PAGEGRIDSIZE! - PAGEMARGINSIZE!) : screenSize!.height)
        )
        
        self.targetDirection = targetDirection
        self.start = start
        self.length = length
        self.targetShade = targetShade
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = 0
        self.alpha = isMiniLevel ? 1 : MINALPHA

        getCurrentSceneType().addChild(self)
        self.label = initGoalLabel()
        self.goalStrokeSprite = createGoalStroke(targetDirection: targetDirection, start: start, length: length, shade: targetShade)
        //adding label to self makes the alpha transparent, so adding to the stroke which is always max alpha
        self.goalStrokeSprite!.addChild(self.label!)
        self.label?.alpha = MAXALPHA
        self.label?.zPosition = 50
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
        label.fontSize = self.isMiniLevel ? setFontSizeFromDevice() : 32
        label.fontColor = SKColor.black
        label.zPosition = 50
        label.fontName = CUSTOMFONT.fontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        self.cgRect = createGoalRect(targetDirection: self.targetDirection!, start: self.start!, length: self.length!)
        //CGPoint coordinates are from bottom left, so screenheight - y is neccessary //SITTING OUTSIDE DATACOM AND FIGURING OUT LABEL POSITIONS MAN
        if(!isMiniLevel){
            label.position = CGPoint(x: self.cgRect!.origin.x + self.cgRect!.width / 2, y:  screenSize!.height - self.cgRect!.origin.y - self.cgRect!.height / 2)
        }
        else if(isMiniLevel){
            label.position = CGPoint(
                x: self.cgRect!.origin.x + self.cgRect!.width / 3,
                y:  (PAGEGRIDSIZE! - PAGEMARGINSIZE!) - (self.cgRect!.origin.y + self.cgRect!.height / 2.3 )
            )
        }
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
        UIGraphicsBeginImageContext(
            self.isMiniLevel ?
                CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!) :
                CGSize(width: screenSize!.width, height: screenSize!.height))
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        ctx.saveGState()
        
        let goal = createGoalRect(targetDirection: targetDirection, start: start, length: length)
        //print("CREATING GOAL RECT: ", goal)
//        if(self.isMiniLevel){
//            goal.origin.y = screenSize!.height - goal.origin.y
//        }
        let clipPath: CGPath = UIBezierPath(roundedRect: goal, cornerRadius: GOALRADIUS).cgPath
        ctx.addPath(clipPath)
        
        let color = UIColor(rgb: ColourScheme.getColour(cut: shade)).withAlphaComponent(self.displayAlpha).cgColor
        
        ctx.setFillColor(color)
        
        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
        
        let goalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return SKTexture(image: goalImage!)
        
    }
    
    func createGoalStroke(targetDirection: Goals.DIRECTION, start: Int, length: Int, shade: Int) -> SKSpriteNode {
        UIGraphicsBeginImageContext(CGSize(width: screenSize!.width, height: screenSize!.height))
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.resetClip()
        
        let goal = createGoalRect(targetDirection: targetDirection, start: start, length: length)
        let clipPath: CGPath = UIBezierPath(roundedRect: goal, cornerRadius: GOALRADIUS).cgPath
        ctx.addPath(clipPath)
        
        let color = UIColor(rgb: ColourScheme.getColour(cut: shade)).cgColor
        
        ctx.setStrokeColor(color)
        ctx.closePath()
        ctx.strokePath()
        
        let goalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let goalTexture = SKTexture(image: goalImage!)
        let goalStrokeSprite = SKSpriteNode(texture: goalTexture)
        goalStrokeSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.getCurrentSceneType().addChild(goalStrokeSprite)
        return goalStrokeSprite
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
        checkGoalNotSolvedAnymore()
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
    func secondGoalCheck(){
        print("CHECKING GOAL FULFILLMENT AGAIN")
        checkNearbyBlob()
    }
    func checkAdjacentBlobSize(blob: Blob) -> Bool {
        switch(self.targetDirection!){
            case Goals.DIRECTION.TOP, Goals.DIRECTION.BOTTOM :
                if (blob.blobRect?.width)! - self.cgRect!.width < DEFAULTGRIDSIZE / 4 {
                    print("GOAL IS COLLIDING")
                    self.b_solved = true
                    //TODO play solved sound
                    //TODO set a timer for three seconds and check if goal is still fulfilled, otherwise it will get cancelled
                    //self.alpha = MAXALPHA

                    //self.run(colorAction, completion: secondGoalCheck )
//                    let fadeAlpha = SKAction.fadeAlpha(to: MAXALPHA, duration: ALPHATRANSITIONSPEED)
//                    self.run(fadeAlpha, completion: secondGoalCheck)
                    return true
                }
            case Goals.DIRECTION.LEFT, Goals.DIRECTION.RIGHT :
                if (blob.blobRect?.height)! - self.cgRect!.height < DEFAULTGRIDSIZE / 4 {
                    print("GOAL IS SOLVED")
                    self.b_solved = true
                    //TODO play solved sound
                    //self.alpha = MAXALPHA
                    return true
            }
        }
        checkGoalNotSolvedAnymore()
        return false
    }
    
    //called from scene to update
    func update(){
        
    }
    
    func checkGoalNotSolvedAnymore(){
        //check if it has been solved and is now disabled
        if(self.b_solved){
            //play loss of goal sound
            print("GOAL IS NOT COLLIDING ANYMORE")
            self.b_solved = !self.b_solved
        }
        //self.alpha = MINALPHA
    }
    
    func setFontSizeFromDevice() -> CGFloat {
        if isiPad == UIUserInterfaceIdiom.pad {
            return 12
        }
        else if isiPad == UIUserInterfaceIdiom.phone {
            //check phone type based on screen size
            if screenSize!.width < 375 {
                //iPhoneX = 375
                return 6
            }
        }
        return 7.35
    }
}

