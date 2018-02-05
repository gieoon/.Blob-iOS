
import Foundation
import SpriteKit

class SwipeManager {
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    let tapRec = UITapGestureRecognizer()
    
    //private var currentSwipeBeginningPoint: CGPoint = CGPoint(x: -100, y: -100)
    private var currentSwipeStartingPoint: CGPoint = CGPoint(x: -100, y: -100)
    
    let playScene: PlayScene?
    
    init(scene: PlayScene){
        self.playScene = scene
    }
    
    func handleSwipe(view: SKView){
//        swipeRightRec.addTarget(self, action: #selector(swipeRight))
//        swipeRightRec.direction = .right
//        view.addGestureRecognizer(swipeRightRec)
//
//        swipeLeftRec.addTarget(self, action: #selector(swipeLeft))
//        swipeLeftRec.direction = .left
//        view.addGestureRecognizer(swipeLeftRec)
//
//        swipeUpRec.addTarget(self, action: #selector(swipeUp))
//        swipeUpRec.direction = .up
//        view.addGestureRecognizer(swipeUpRec)
//
//        swipeDownRec.addTarget(self, action: #selector(swipeDown))
//        swipeDownRec.direction = .down
//        view.addGestureRecognizer(swipeDownRec)
        
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
//        if(sender.state == .began){
//            self.currentSwipeBeginningPoint = sender.location(in: sender.view)
//            print("SWIPE BEGINNING DETECTED")
//        }
        if(sender.state == .ended){
            
            print("SWIPE ENDING DETECTED")
            
            self.currentSwipeStartingPoint = sender.location(in: sender.view)
            
            switch(sender.direction){
                case .up :
                    self.splitUp()
                
                case .down :
                    self.splitDown()
                
                case .left :
                    self.splitLeft()
                
                default :
                    self.splitRight()
                
            }
        }
    }
    
    @objc
    func splitRight(){
        print("SWIPE RIGHT DETECTED")
        let blob = detectCollidingBlob()
        snapTouchToGrid()
        
        print("self.currentSwipeStartingPoint: ", self.currentSwipeStartingPoint)
        createNewBlob(
            x: (blob?.blobSprite?.position.x)!,
            y: (blob?.blobSprite?.position.y)!,
            width: (blob?.blobSprite?.size.width)!,
            height: self.currentSwipeStartingPoint.y - (blob?.blobSprite?.position.y)!,
            shade: (blob?.shade)! + 1
        )
        
        blob!.blobSprite?.removeFromParent()
        deleteFromArray(element: blob!)
    }
    @objc
    func splitLeft(){
        print("SWIPE LEFT DETECTED")
    }
    @objc
    func splitUp(){
        print("SWIPE UP DETECTED")
    }
    @objc
    func splitDown(){
        print("SWIPE DOWN DETECTED")
    }
    
    @objc
    func tapped(_ sender:UITapGestureRecognizer){
            //TODO for dropping
    }
    
    
    func snapTouchToGrid(){
        self.currentSwipeStartingPoint.x = (self.currentSwipeStartingPoint.x / PLAYGRIDSIZE!).rounded()
        self.currentSwipeStartingPoint.y = ((self.currentSwipeStartingPoint.y - PLAYGRIDY0!) / PLAYGRIDSIZE!).rounded()
    }
    
    func detectCollidingBlob() -> Blob? {
        for blob in (self.playScene?.blobs)! {
            if(blob.blobSprite!.contains(self.currentSwipeStartingPoint)){
                return blob
            }
        }
        return nil
    }
    
    func deleteFromArray(element: Blob) {
        //creates new array eliminating this element
        self.playScene?.blobs = (self.playScene?.blobs.filter() { $0 !== element })!
    }
    
    func createNewBlob(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, shade: Int){
        
        self.playScene?.blobs.append(Blob(x: x, y: y, width: width, height: height, shade: shade, scene: self.playScene!))
    }
    
    
}
