//
//  Goal.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

import SpriteKit

class Goal: SKSpriteNode {
    
    var start, length: CGFloat?
    var label = SKLabelNode()
    
    enum DIRECTION {
        case TOP
        case BOTTOM
        case LEFT
        case RIGHT
    }
    var targetDirection: DIRECTION?
    var targetShade: Int?
    
    init(targetDirection: DIRECTION, start: CGFloat, length: CGFloat, targetShade: Int){
        super.init(
            texture: nil,
            color: UIColor.black,
            size: CGSize(width: PAGEGRIDSIZE! - PAGEMARGINSIZE!, height: PAGEGRIDSIZE! - PAGEMARGINSIZE!)
        )
        self.targetDirection = targetDirection
        self.start = start
        self.length = length
        self.targetShade = targetShade
        print("goal created: ",self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
