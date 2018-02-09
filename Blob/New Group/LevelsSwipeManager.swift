//
//  LevelsSwipeManager.swift
//  Blob
//
//  Created by gieoon on 2018/02/08.
//  Copyright © 2018 shunkagaya. All rights reserved.
//


import Foundation
import SpriteKit

class LevelsSwipeManager {
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    var sliceDirection: String = ""
    
    //private var currentSwipeBeginningPoint: CGPoint = CGPoint(x: -100, y: -100)
    private var currentSwipeStartingPoint: CGPoint = CGPoint(x: -100, y: -100)
    
    let levelsScene: LevelsScene?
    
    init(scene: LevelsScene){
        self.levelsScene = scene
    }
    
    func handleSwipe(view: SKView){
        
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
        tapRec.addTarget(self, action:#selector(tapped(_:) ))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRec)
    }
    
    @objc
    func swipe(sender: UISwipeGestureRecognizer){
        
        if(sender.state == .ended){
        
            switch(sender.direction){
                case .up :
                    //print("SWIPE UP DETECTED")N
                    self.levelsScene!._toMenu()
                case .down :
                    //print("SWIPE DOWN DETECTED")
                    self.levelsScene!._toMenu()
                case .left :
                    //print("SWIPE LEFT DETECTED")
                    self.levelsScene!.increasePage()
                default :
                    //print("SWIPE RIGHT DETECTED")
                    self.levelsScene!.decreasePage()
            }
        }
    }
    
    @objc
    func tapped(_ sender:UITapGestureRecognizer){
        print("TAP DETECTED")
        //TODO for selecting level?
        
        self.levelsScene!.checkTouch(touchPoint: sender.location(in: sender.view!))
    }
}


