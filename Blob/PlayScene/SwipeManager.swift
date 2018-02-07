
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
            
            //by making this an "if" statement, all of the blob instances below do not require unwrapping
            if let blob = detectCollidingBlob(){
                
                snapTouchToGrid()
                
                print("self.currentSwipeStartingPoint: ", self.currentSwipeStartingPoint)
                
                if(checkSliceLegality(blob: blob)){
                
                    switch(sender.direction){
                        case .up :
                            splitUp(blob: blob)
                        
                        case .down :
                            splitDown(blob: blob)
                        
                        case .left :
                            splitLeft(blob: blob)
                        
                        default :
                            splitRight(blob: blob)
                        
                    }
                    
                    blob.blobSprite?.removeFromParent()
                    blob.label?.removeFromParent()
                    deleteFromArray(element: blob)
                    print("DELETED A BLOB")
                }
            }
        }
    }
    
    func checkSliceLegality(blob: Blob) -> Bool{
        if(Int(self.currentSwipeStartingPoint.y) > blob.gridY){
            //print("LEGALITY CHECK RETURNING TRUE")
            return true
        }
        return false
    }
    
    func splitRight(blob: Blob){
        print("SWIPE RIGHT DETECTED")
        
            createNewBlob(
                x: (blob.gridX),
                y: (blob.gridY),
                width: (blob.gridWidth),
                height: Int(self.currentSwipeStartingPoint.y) - (blob.gridY),
                shade: (blob.shade) + 1
            )
            createNewBlob(
                x: (blob.gridX),
                y: Int(self.currentSwipeStartingPoint.y),
                width: (blob.gridWidth),
                height: (blob.gridHeight + blob.gridY) - Int(self.currentSwipeStartingPoint.y),
                shade: (blob.shade) + 1
            )
        
    }


    func splitLeft(blob: Blob){
        print("SWIPE LEFT DETECTED")
    }

    func splitUp(blob: Blob){
        print("SWIPE UP DETECTED")
    }

    func splitDown(blob: Blob){
        print("SWIPE DOWN DETECTED")
        
        createNewBlob(
            x: blob.gridX,
            y: blob.gridY,
            width: Int(self.currentSwipeStartingPoint.x) - blob.gridX,
            height: blob.gridHeight,
            shade: blob.shade + 1
        )
        createNewBlob(
            x: Int(self.currentSwipeStartingPoint.x),
            y: blob.gridY,
            width: blob.gridWidth,
            height: (blob.gridHeight + blob.gridY) - Int(self.currentSwipeStartingPoint.y),
            shade: blob.shade + 1
        )
    }
    
    @objc
    func tapped(_ sender:UITapGestureRecognizer){
            //TODO for dropping
    }
    
    func snapTouchToGrid(){
        currentSwipeStartingPoint.x = (currentSwipeStartingPoint.x / PLAYGRIDSIZE!).rounded()
        currentSwipeStartingPoint.y = (((currentSwipeStartingPoint.y) - PLAYGRIDY0!) / PLAYGRIDSIZE!).rounded()
    }
    
    func detectCollidingBlob() -> Blob? {
        for blob in (self.playScene?.blobs)! {
            if(blob.blobSprite!.contains(self.currentSwipeStartingPoint)){
                //check is not a boundary
                if     (Int(self.currentSwipeStartingPoint.y) != blob.gridY)
                    && (Int(self.currentSwipeStartingPoint.y) != blob.gridY + blob.gridHeight)
                    && (Int(self.currentSwipeStartingPoint.x) != blob.gridX)
                    && (Int(self.currentSwipeStartingPoint.x) != blob.gridX + blob.gridWidth){
                    return blob
                }
            }
        }
        return nil
    }
    
    func deleteFromArray(element: Blob) {
        //creates new array eliminating this element
        self.playScene?.blobs = (self.playScene?.blobs.filter() { $0 !== element })!
    }
    
    func createNewBlob(x: Int, y: Int, width: Int, height: Int, shade: Int){
        print("CREATING NEW BLOB WITH X: ", x, " Y: ", y, " WIDTH: ", width, " HEIGHT: ", height)
        self.playScene?.blobs.append(Blob(x: x, y: y, width: width, height: height, shade: shade, scene: self.playScene!))
    }
    
    
}
