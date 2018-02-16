//
//  GameViewController.swift
//  Blob
//
//  Created by shunkagaya on 15/11/2017.
//  Copyright © 2017 shunkagaya. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import os.log

//global variables
var SKViewSize: CGSize?
var SKViewSizeRect: CGRect?
var screenSize: CGRect?
var PAGEGRIDSIZE: CGFloat?, PLAYGRIDSIZE: CGFloat?, PAGEMARGINSIZE: CGFloat?, SMALLESTSIDE: CGFloat?, GRIDSIZE: CGFloat?
var PLAYGRIDX0, PLAYGRIDXMAX, PLAYGRIDY0, PLAYGRIDYMAX, MINILEVELGRIDSIZE: CGFloat?
var json4Swift_Base: Json4Swift_Base?
var BUTTON_WIDTH_SCALE: CGFloat = 0.17
var BUTTON_HEIGHT_SCALE: CGFloat = 0.1
var TRANSITIONSPEED: TimeInterval = 1.5
var BACKGROUNDCOLOUR: UIColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
var CUSTOMFONT: UIFont = loadFont()
var isiPad: UIUserInterfaceIdiom?
var MAXALPHA: CGFloat = 1.0 //adds 0.7
var MINALPHA: CGFloat = 0.3
var ALPHATRANSITIONSPEED: TimeInterval = 1.0
var ALPHACHANGEAMOUNT: CGFloat = 0.15
//var rightPage, leftPage: LevelsScene? //left and right pages of the adjacents levels to what is currently in view.
var currentPage: Int = 0
var totalSlices: Int = 0

public enum GAMESTATE {
    case LOADING
    case MENU
    case LEVELS
    case PLAYING
}
var gamestate: GAMESTATE = GAMESTATE.LOADING

//ipad will have a camera to simulate zoom
//let cameraNode = SKCropNode()


//loading all textures


//creating texture Atlas from code @ runtime
//guard let borderImage = UIImage(named: "game_border.png"),
//    let titleImage = UIImage(named: "title_banner.png") else {
//        print("UNABLE TO RESOLVE ALL IMAGES")
//        return
//}

//let textureAtlas = SKTextureAtlas(dictionary: [
//    "border": borderImage,
//    "title": titleImage
//    ]).preload {
//        print("TEXTURES PRELOADING COMPLETE")
//}

//var play_button: SKSpriteNode?
//var settings_button: SKSpriteNode?
//var help_button: SKSpriteNode?
//var gameBorder1: SKSpriteNode?
//var gameBorder2: SKSpriteNode?
//var title_banner: SKSpriteNode?
//var reset_button: SKSpriteNode?
//var lvls_button: SKSpriteNode?

var gameScene: GameScene?
var levelsScene: LevelsScene?
var playScene: PlayScene? //always make this nil after use
//var spriteRows = [SKSpriteNode]()
//var spriteColumns = [SKSpriteNode]()//.self

class GameViewController: UIViewController {
    //link to the GameScreen
    //TODO change to loading scene
    var scene: GameScene!
    
    //var scene: LoadingScene!
    //instead of initializng as 0, create as an optional
    public var screenWidth: CGFloat?, screenHeight: CGFloat?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var shouldAutorotate: Bool {
        return true
    }
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        //the types of device display allowed??
//        return [.portrait, .portraitUpsideDown]
//    }
    
//    static func getCurrentScene() -> SKScene? {
//        switch(gamestate){
//            case GAMESTATE.LOADING : return loadingScene!
//            case GAMESTATE.MENU : return gameScene!
//            case GAMESTATE.LEVELS : return levelsScene!
//            case GAMESTATE.PLAYING : return nil
//        }
//    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        isiPad = readDeviceType()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize!.width
        screenHeight = screenSize!.height
        
        //LOADING
        Assets._sharedInstance.preloadAssets()
        Assets._sharedInstance.loadJSONFromFile()
        AudioManager._audioInstance.loadAudio()
        setGridSizes()
        GameViewController.initFromNSCoder()
        //createDashedGrid()
        
        print("screen width: \(String(describing: screenWidth)), screen height = \(String(describing: screenHeight))")
        //os_log("screen width: \(screenWidth), screen height = \(screenHeight)", type: OS_LOG_T)
        //os_log("Configure %{public}@", screenHeight)
        //NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //let skView = self.view as! SKView
        //LoadingOverlay.shared.showOverlay(view: view)
        
        if var view = self.view as! SKView? {
            
            view.isMultipleTouchEnabled = false
            
            SKViewSize = self.view.bounds.size
            
            // Load the SKScene from 'GameScene.sks'
            //this is the menu sceen scene
            //if let scene = SKScene(fileNamed: "GameScene") {
            
            scene = GameScene(size: view.bounds.size)
            //only gamescene works, all otehr scenes DO NOT WORK to start with...
            
            // Set the scale mode to scale to fit the window
            //scene.scaleMode = .aspectFill
            //removing anchor positioning and using sprie relative positioning and drawing
            //scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //scene.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            SKViewSizeRect = getViewSizeRect()
        }
        
        //LoadingOverlay.shared.hideOverlayView()
    }
    //euverus traffic simulation
    //when the view bouns change / rotation?
    //override func viewWilltransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator){
    //override func viewDidLayoutSubviews(){
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //@objc func rotate(){
        super.viewDidLayoutSubviews()
        SKViewSize = self.view.bounds.size
        SKViewSizeRect = getViewSizeRect()
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height //SKViewSize?.height
        setGridSizes()
        print("AFTER ROTATION: screen width: \(String(describing: screenWidth)), screen height = \(String(describing: screenHeight))")
        var skView = self.view as! SKView
        if var scene = skView.scene {
            scene.size = self.view.bounds.size
        }
    }
    
    //"The difference between coding a 2-hour platformer and a 20-hour RPG: 62 gray hairs, 7 doctor co-payments, and 2,000 hours. #gamedev"
    //"After two years of toiling, sleepless night and neglected wives we're finally close to releasing an #EchoesofEternea game demo. #gamedev"
    
    func getViewSizeRect() -> CGRect {
        return CGRect(x: ((SKViewSize!.width * 0.5) * -1.0), y: ((SKViewSize!.height * 0.5) * -1.0), width: SKViewSize!.width, height: SKViewSize!.height)
    }
    
    func setGridSizes(){
        if(screenSize!.width > screenSize!.height){
            //print("width is larger than height")
            PAGEMARGINSIZE = screenSize!.height / 10
            PAGEGRIDSIZE = screenSize!.height / 3.2
            SMALLESTSIDE = screenSize!.height
            MINILEVELGRIDSIZE = (PAGEGRIDSIZE! - PAGEMARGINSIZE!) / 10
        }
        else{
            //print("height is larger than width")
            PAGEMARGINSIZE = screenSize!.width / 15
            PAGEGRIDSIZE = screenSize!.width / 3.5
            SMALLESTSIDE = screenSize!.width
            MINILEVELGRIDSIZE = (PAGEGRIDSIZE! - PAGEMARGINSIZE!) / 10
        }
        setPlayGridSizes()
        //print ("NEW PAGEMARGINSIZE: \(PAGEMARGINSIZE),  PAGEGRIDSIZE: \(PAGEGRIDSIZE)")
        print("MINILEVELGRIDSIZE: ", MINILEVELGRIDSIZE!)
    }
    
    func setPlayGridSizes(){
        PLAYGRIDSIZE = screenSize!.width / 10 // grid is 8 X 8 excluding 1 grid margin on each side
        PLAYGRIDY0 = screenSize!.height / 5
        print("PLAYGRIDSIZE!: ", PLAYGRIDSIZE!)
        //new coordinates for iPad
        if(isiPad == UIUserInterfaceIdiom.pad){
            print("IS IPAD")
            PLAYGRIDY0 = screenSize!.height / 15
        }
    }
    
    //create dashed grid beforehand because it is time consuming.
    //Deprecated & replaced this with a sprite image, drawing is too time consuming.
    func createDashedGrid() {
        var dashPattern : [CGFloat] = [0.15, 5.5]
        //draw dotted line representing grid
        var spriteRow, spriteColumn: SKSpriteNode
        //UIGraphicsBeginImageContext(scene!.size)
        //let ctx: CGContext = UIGraphicsGetCurrentContext()!
        //did this using CGContext, CGMutablePath, and UIBezierPath, until finally one worked...
        //all of those have a different coordinate system...CGContext 0 is in the middle of screen, while UIBezier Path is top left...
        for row in 1...9 {
            //let path = CGMutablePath()
            var path = UIBezierPath()
            
            //path.copy(dashingWithPhase: 2, lengths: pattern)
            
            
            //            ctx.saveGState()
            //            ctx.beginPath()
            //            ctx.setLineWidth(8.0)
            //            ctx.setLineCap(.round)
            //            ctx.setStrokeColor(UIColor.black.cgColor)
            //            ctx.setFillColor(UIColor.black.cgColor)
            
            
            var point0 = CGPoint(x: PLAYGRIDSIZE! * 0.5, y: (CGFloat(row) * PLAYGRIDSIZE!) + PLAYGRIDY0!)
            //let point0 = CGPoint(x: 0, y: 0)
            path.move(to: point0)
            //path.addLine(to: point0)
            //ctx.move(to: point0)
            //ctx.addLine(to: point0)
            
            var point1 = CGPoint(x: PLAYGRIDSIZE! * 9.5, y: (CGFloat(row) * PLAYGRIDSIZE!) + PLAYGRIDY0!)
            //let point1 = CGPoint(x: 375, y: 667)
            path.addLine(to: point1)
            //ctx.move(to: point1)
            //ctx.addLine(to: point1)
            
            //let dashes: [ CGFloat ] = [ 0, PLAYGRIDSIZE!, PLAYGRIDSIZE! * 2, PLAYGRIDSIZE! * 3, PLAYGRIDSIZE! * 4, PLAYGRIDSIZE! * 5 ]
            //ctx.setLineDash(phase: 0.0, lengths: dashes)
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.lineCapStyle = CGLineCap.round
            //path.lineCapStyle = .butt
            
            var renderer = UIGraphicsImageRenderer(size: screenSize!.size)
                //CGSize(width: PLAYGRIDSIZE! * 10, height: (PLAYGRIDSIZE! * 10)))
            var dashedImage = renderer.image {
                context in path.stroke(with: CGBlendMode.normal, alpha: 0.3)
            }
            //scene?.addChild(renderer)
            //            let shape = SKShapeNode(path: path.copy(dashingWithPhase: 2, lengths: dashPattern))
            //            shape.path = path
            //            shape.strokeColor = UIColor.black
            //            shape.lineWidth = 2
            //            addChild(shape)
            //ctx.strokePath()
            //print("SHAPE.path IS: ", shape.path)
            
            //            let dashedImage = UIGraphicsGetImageFromCurrentImageContext()
            var dashedTexture = SKTexture(image: dashedImage)
            var dashedSprite = SKSpriteNode(texture: dashedTexture)
            dashedSprite.anchorPoint = CGPoint(x: 0, y: 0)
            //spriteRows.append(dashedSprite)
            //print(dashedSprite)
            
            //ctx.closePath()
            //ctx.fillPath()
            //ctx.restoreGState()
        }
        //UIGraphicsEndImageContext()
        
        for column in 1...9 {
            var path = UIBezierPath()
            
            var point0 = CGPoint(x: CGFloat(column) * PLAYGRIDSIZE!, y: (PLAYGRIDSIZE! * 0.5) + PLAYGRIDY0!)
            path.move(to: point0)
            
            var point1 = CGPoint(x: CGFloat(column) * PLAYGRIDSIZE!, y: (PLAYGRIDSIZE! * 9.5) + PLAYGRIDY0!)
            path.addLine(to: point1)
            
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.lineCapStyle = CGLineCap.round
            //path.lineCapStyle = .butt
            
            var renderer = UIGraphicsImageRenderer(size: screenSize!.size)
            var dashedImage = renderer.image {
                context in path.stroke(with: CGBlendMode.lighten, alpha: 0.3)
            }
            
            var dashedTexture = SKTexture(image: dashedImage)
            var dashedSprite = SKSpriteNode(texture: dashedTexture)
            dashedSprite.anchorPoint = CGPoint(x: 0, y: 0)
            //scene?.addChild(dashedSprite)
            //spriteColumns.append(dashedSprite)
        }
        //return DoubleSprite(row: spriteRow, column: spriteColumn)
    }
    
//    struct DoubleSprite {
//        var row, column : SKSpriteNode
//
//        init (row: SKSpriteNode, column: SKSpriteNode){
//            self.row = row
//            self.column = column
//        }
//    }
    
    //get device type
    func readDeviceType() -> UIUserInterfaceIdiom {
        //UI_USER_INTERFACE_IDIOM() ==
        switch(UIDevice.current.userInterfaceIdiom){
            case .pad :
                print("iPad detected")
                return UIUserInterfaceIdiom.pad
            case UIUserInterfaceIdiom.phone :
            print("phone detected")
            return UIUserInterfaceIdiom.phone
        
            default :
            print("unspecified device detected")
            return UIUserInterfaceIdiom.unspecified
        }
    }
    
    //set global varibale currentPage, based on what is available.
    public static func initFromNSCoder() {
        //initially, for testing, load data into memory
//        DataStorage._sharedInstance.dataToSave.currentLevel = 1
//        DataStorage._sharedInstance.dataToSave.totalSlices = 2
//        DataStorage._sharedInstance.dataToSave.unlockedLvl = 3
//        print("STORED DATA IS: ", DataStorage._sharedInstance.dataToSave)
//        DataStorage._sharedInstance.saveData()
        
        //load the data from memory into static variable
        DataStorage._sharedInstance.loadData()
        //retrieve from static variable into global variable
        
        currentPage = DataStorage._sharedInstance.dataToSave.currentLevel! / 9
        totalSlices = DataStorage._sharedInstance.dataToSave.totalSlices!
        print("currentPage is: ", currentPage)
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

public extension SKNode {
    //creating custom method
    public func posByScreen(x: CGFloat, y: CGFloat){
        //self.position = CGPoint(x: CGFloat((SKViewSizeRect!.width * x) + SKViewSizeRect!.origin.x), y: CGFloat((SKViewSizeRect!.height * y) + SKViewSizeRect!.origin.y))
        self.position = CGPoint(x: CGFloat((screenSize!.width * x) + screenSize!.origin.x), y: CGFloat((screenSize!.height * y) + screenSize!.origin.y))
    }

}

public extension SKSpriteNode {
    //resizes based on screen width
    public func resizeByScreen(x: CGFloat, y: CGFloat){
        //self.xScale = screenSize!.width * x
        //self.yScale = screenSize!.height * y
        //scaleToSize(CGSize(screenSize!.width / x))
        self.size.width = screenSize!.width * x
        self.size.height = screenSize!.height * y
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int){
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

func loadFont() -> UIFont {
    //default loop to find all font names which is not obvious
    //        for family in UIFont.familyNames.sorted() {
    //            let names = UIFont.fontNames(forFamilyName: family)
    //            print("Family: \(family) Font names: \(names)")
    //        }
    guard let customFont = UIFont(name: "Orbitron-Regular", size: UIFont.labelFontSize) else {
        fatalError("""
                Failed to load the "Orbitron-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly
            """)
    }
    return customFont
}

//
//wonder if you and I have the same mother and are sister/brother, but never mind... :)
//
//For decades, my Mom has been exactly the same. Same words, same ideas, same problems, same questions, as the ones you just mentioned to us. And I've tried, just like you. Almost everything, until I reached the point of "nothing else to say". Mom's always right :)
//
//From "Mom, please don't buy too much food, as we don't eat that much, and my GF doesn't eat [ X / Y ] (that you like to buy for us)" to "You'd rather do this like that, son, it's not going to work", I've said and heard almost everything. Almost.
//
//What I found out is that Moms (at least, mine, lucky me!) like to take care of their kids. No matter what happens, how old you get, you're still "her kid". She'll try and protect you, anytime, anywhere, no matter what, or the cost for her. It's part of their pride of being a good Mom.
//
//    Mine thinks I'm still 15. Wish it could be the case, though...
//
//About the "too much food" part, I managed to show her that she was wasting, as we couldn't eat everything. Then, ask her, before we visit her, if she could cook just ONE meal, my favourite. And add (on the phone), that it would be the best for me: spend time with you, and the pleasure of my "Proust's « sponge cake »". That would be the only thing to make me the happiest son of all. Not more.
//
//This way, she was sure that I would have had enough. A Mom's concern. I had deflected, relieved her from willing to do more and more, and the stress attached to it. Then, a loooong, big hug and a gentle kiss on her cheek would be enough for both of us.
//
//If you can't have her stop, then ask for more. YOUR more, just ONE thing she can focus on. It'll be less stress and work for her, but this way, she'll know she has done what "a perfect mother" has to do: make her kid happy :)
//
//Took years before I get the trick, now, it works all the time.

//However, the Roman empire encompassed a large amount of time and a large amount of technological innovation. Just as my grandmother during her lifetime saw the horse-and-buggy and steam ships as the pinnacle of transportation technology give way to walking on the moon and air flight so common people don't dress up for it any more, the Romans shifted from their early years ("absolutely not") to 300ish AD when the answer becomes "possibly, maybe even probably."
//
//A number of commenters have expressed disbelief that reverse engineering can bring substantial value to the technological innovation process. Their premise is that the technologies didn't develop for a millennia or more on their own, which assumes they couldn't have developed in 200-300 years with a working example to experiment with or to motivate them.
//
//Such commenters have no experience with reverse engineering. I do. Knowing that something is possible and you only need to duplicate it is much, much, much more powerful than not knowing something is possible and waiting around for the combination of imagination and scientific development to merge.
//
//The simple truth is if the Romans were shown with irrefutable proof the value of a working steam engine, they wouldn't have one or two guys out there tinkering around with a vague idea (which is why it took millennia naturally). They'd have thousands and more people dedicated to realizing the military advantage. (Unless as previously indicated you want to choose that they don't see the value, in which case this is all a moot conversation. You won't invent what you don't care about.)
//
//Some people like to think that innovation is somehow a fixed process, that it can't happen any faster than it did, but our own recent history in computer development has proven that wrong time and time again.
//
//You need not understand why something works to duplicate it.
//
//To conclude with an example, I wonder if some believe the specifications of an antique steam engine are as difficult to achieve as a 2017 combustion engine. Obviously, the metals and precision needed for a 2017 engine could not be duplicated by the romans during their time. But that isn't what was asked for. When I once read The Grapes of Wrath I noted a moment in the story when the family had to repair their engine. They'd lost compression, so they wrapped copper wire around the piston, shoved it back into the chamber, and off they went. I wondered about that and so asked my grandmother, who said things like that did, indeed, happen. That's an awful lot of imprecision to still have a working and useful engine.
//
//If you still want to believe the Romans couldn't reverse engineer something as simple as a steam engine (with operating documents!) under the conditions I've specified, by all means, downvote my answer. I won't feel bad.
//shareimprove this answer
//
//edited 2 days ago
//
//answered Nov 20 at 17:48
//JBH
//9,38711650
//
//2
//
//Most of the innovation related points have been well covered in other answers. This includes the Aeolipyle. Other mechanical concepts of converting circular motion into linear (screw) also existed.
//
//Could the Romans have copied the steam engine? Yes!
//
//Would the Romans have copied the steam engine? Maybe!
//
//Could/Would the Romans have used the steam engine? NO!
//
//Technology isn't developed because it can be, it is developed because it must be. There are several forces at work here. Someone needs to fund the research and development. Someone needs to invest a lot of money and resources towards the critical initial growth of the technology. There needs to be sufficient scope for returns on investment. If the new technology is disruptive, then there will also be opposition from stakeholders in the existing technology that will be affected. If the new technology is extremely prolific and could affect the balance of political power, then politics will play a part as well.
//
//The OP has not specified a date/period so lets assume the Roman empire is already established. The Romans are spread thin and find it difficult to simultaneously control their entire empire with insurgency issues everywhere. Can the steam engine aid them in consolidating their empire? Or will the emergence of a steam engine ruin existing economy and consequently their grip on the empire? Even worse, the steam engine could well fall in the hands of rebellious entities in the empire and serve as force multiplier, which once again leads to the fall of the Roman empire. In view of potentially counter productive influence of steam engine technology, the Romans may choose not to build it.
//
//In the modern era, we have a similar situation with regards to alternative energy sources. The powerful transportation and energy lobby supporting conventional sources like gas and coal are opposing alternatives. Could we develop energy efficient solar cells, wind turbines, etc? Sure! But are we? Well, kinda, to the extent that it is being allowed to and not more. What will happen to the livelihoods of millions of workers directly and indirectly affected by the gas and coal industry? What will happen to their votes? Will availability of cheap energy alter the balance of geo-political power?
//
//It's extremely common in the modern market for someone to come up with a new exciting product that opens up a whole new field (iPod, iPhone, Ford's Model T, IBM PCs, and so on) to be copied in short order. Competitors will quickly acquire copies of the invention then tweak it to make it their own. This process of copying is so widespread that patents exist to give the inventor a little breathing room to make some money before facing strong competition.
//
//A significant portion of the time spent in the process of invention is finding all the things that don't work. Handing the inventive, industrious and power hungry Romans a working example of a small steam engine that can do real work would light off a firestorm of investment. I trust that they're smart enough to realize that a machine that can do real work without muscle, whip or feed is a huge improvement.
//
//I think most people assume that the Romans would immediately jump straight to the enormous steam engines of mid-1800s Europe involving cast steel parts with highly precise machined faces and surfaces. I disagee. Given that the example they have is small, they will likely build small, low precision examples at first. Due to the imprecision, these machines won't be efficient. They won't have the theory to drive the math to get higher efficiency, at least not to start.

//Comments are not for extended discussion; this conversation has been moved to chat. – JDługosz♦ Nov 21 at 6:27
//13
//
//Check these Roman compressed-air ballista from Saalburg Kastell, Germany. I've seen them in person, and read the plaque saying that they performed poorly as the Roman metalworkers did not get the seals as airtight as necessary. So I think the Romans would have "gotten the idea" pretty quickly, but would be hard-pressed to produce an engine with the precision necessary to be effective... – DevSolar Nov 21 at 12:40
//2
//
//@AcePL, :-) my guess is that you didn't read the nine miles of comments JDlugosz moved to chat. – JBH Nov 21 at 15:15
//3
//
//@jamesqf You click on the link 'moved to chat' above and go read them. – robertc Nov 21 at 18:55
//34
//
//You need not understand why something works to duplicate it. - As a computer scientist, I can promise this is true. – Lord Farquaad Nov 21 at 22:05
//show 16 more comments
//up vote
//33
//down vote
//
//
