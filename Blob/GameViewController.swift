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

class GameViewController: UIViewController {
    var scene: GameScene!
    let screenSize: CGRect = UIScreen.main.bounds
    public var screenWidth: CGFloat = 0, screenHeight: CGFloat = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        print("screen width: \(screenWidth), screen height = \(screenHeight)")
        
        //let skView = self.view as! SKView
        if let view = self.view as! SKView? {
            view.isMultipleTouchEnabled = false
            // Load the SKScene from 'GameScene.sks'
            //this is the menu sceen scene
            //if let scene = SKScene(fileNamed: "GameScene") {
            scene = GameScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 239/255, alpha: 1)
            loadHomeScreen(scene: scene)
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadHomeScreen(scene: GameScene){
        //title banner
        let title_banner = SKSpriteNode(imageNamed: "blob_banner.png")
        //title_banner.position = CGPoint()
        scene.addChild(title_banner)
        
        //play button
        //var play_button: SKNode! = nil
        let play_button = SKSpriteNode(imageNamed: "bttn_play")
        play_button.position = CGPoint(x: 0.5, y: (1 / 4.0) * 3)
        scene.addChild(play_button)
        
        
        //settings button
        
        //help - credits button
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
