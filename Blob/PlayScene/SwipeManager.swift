
import Foundation
import SpriteKit

class SwipeManager {
    
    var swipeRightRec = UISwipeGestureRecognizer()
    var swipeLeftRec = UISwipeGestureRecognizer()
    var swipeUpRec = UISwipeGestureRecognizer()
    var swipeDownRec = UISwipeGestureRecognizer()
    var tapRec = UITapGestureRecognizer()
    var sliceDirection: String = ""
    var reset_button, lvls_button: SKSpriteNode
    //private var currentSwipeBeginningPoint: CGPoint = CGPoint(x: -100, y: -100)
    private var currentSwipeStartingPoint: CGPoint = CGPoint(x: -100, y: -100)
    private var currentSwipeStartingPointRounded: CGPoint = CGPoint(x: -100, y: -100)
    
    var playScene: PlayScene?
    
    init(scene: PlayScene, reset_button: SKSpriteNode, lvls_button: SKSpriteNode){
        self.playScene = scene
        self.reset_button = reset_button
        self.lvls_button = lvls_button
    }
    
    func handleSwipe(view: SKView){
        print("HANDLE SWIPE CALLED")
        var directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
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
                //print("COLLIDING WITH BLOB.X: ", blob.gridX, " blob.gridY: ", blob.gridY, " blob.gridWidth: ", blob.gridWidth, " blob.gridHeight: ", blob.gridHeight )

                if (blob.gridWidth == 1 && blob.gridHeight == 1) {
                    print("removing 1 X 1 blob")
                    removeBlob(blob: blob)
                    return
                }
                
                if(sender.direction == .up || sender.direction == .down)
                    && (blob.gridWidth == 1){
                        print("cannot VERTICALLY slice blob of width 1")
                        return
                    
                }
                else if(sender.direction == .left || sender.direction == .right)
                    && (blob.gridHeight == 1){
                        print("cannot HORIZONTALLY slice blob of height 1")
                        return
                    
                }
                else if blob.shade == 10 {
                    print("REMOVING BLOB WITH MAXIMUM SHADE")
                    removeBlob(blob: blob)
                    return
                }
                else {
                    snapTouchToGrid()
                    
                    print("self.currentSwipeStartingPoint: ", self.currentSwipeStartingPoint)
                    
                    if(checkSliceLegality(blob: blob)){
                        
                        switch(sender.direction){
                        case .up :
                            print("SWIPE UP DETECTED")
                            splitVertical(blob: blob)
                            
                        case .down :
                            print("SWIPE DOWN DETECTED")
                            splitVertical(blob: blob)
                            
                        case .left :
                            print("SWIPE LEFT DETECTED")
                            splitHorizontal(blob: blob)
                            
                        default :
                            print("SWIPE RIGHT DETECTED")
                            splitHorizontal(blob: blob)
                        }
                        removeBlob(blob: blob)
                    }
                }
            }
        }
    }
    
    func removeBlob(blob: Blob){
        self.playScene?.removeChildren(in: [blob.blobSprite! as SKNode])
        self.playScene?.removeChildren(in: [blob.label! as SKNode])
        blob.blobSprite?.removeFromParent()
        blob.label?.removeFromParent()
        deleteFromArray(element: blob)
        print("DELETED A BLOB")
        
        for b in (self.playScene?.blobs)! {
            //check for dropping
            b.drop()
        }
        
        for goal in (self.playScene?.goals  )! {
            goal.checkNearbyBlob()
            //TODO start tweens and animations for solved vs not solved
        }
        
        //update the total slices global variable
        totalSlices += 1
    }
    
    func checkSliceLegality(blob: Blob) -> Bool{
        //if(Int(self.currentSwipeStartingPoint.y) > blob.gridY){
            //print("LEGALITY CHECK RETURNING TRUE")
            return true
        //}
        //return false
    }
    
    func splitHorizontal(blob: Blob){
        
        self.sliceDirection = "HORIZONTAL"
        
        if boundaryCheck(blob: blob){
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
    }

    func splitVertical(blob: Blob){
        
        self.sliceDirection = "VERTICAL"
        
        if boundaryCheck(blob: blob){
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
                width: (blob.gridWidth + blob.gridX) - Int(self.currentSwipeStartingPoint.x),
                height: blob.gridHeight,
                shade: blob.shade + 1
            )
        }
    }
    
    @objc
    func tapped(_ sender:UITapGestureRecognizer){
        //TODO for dropping
        var touchPoint = CGPoint(
            x: sender.location(in: sender.view!).x,
            y: screenSize!.height - sender.location(in: sender.view!).y
        )
        if reset_button.contains(touchPoint){
            print("RESET BUTTON WAS TOUCHED")
            self.playScene!.resetPlayScene()
        }
        else if lvls_button.contains(touchPoint){
            print("lvls_button was pressed")
            self.playScene!._toLevels()
        }
        
    }
    
    func snapTouchToGrid(){
        //TODO check each tick for a collision with a blob, and get the first collision found. This is the blob to slice.
        //TODO create a touchline
        
        //get exact values to check is not a boundary
        currentSwipeStartingPointRounded.x = currentSwipeStartingPoint.x
        currentSwipeStartingPointRounded.y = currentSwipeStartingPoint.y
        
        currentSwipeStartingPoint.x = (currentSwipeStartingPoint.x.rounded() / PLAYGRIDSIZE!).rounded()
        currentSwipeStartingPoint.y = ((currentSwipeStartingPoint.y.rounded() - PLAYGRIDY0!) / PLAYGRIDSIZE!).rounded()
    }
    
    func detectCollidingBlob() -> Blob? {
        for blob in (self.playScene?.blobs)! {
            if(blob.blobRect!.contains(
//                CGPoint(
//                    x: self.currentSwipeStartingPoint.x * PLAYGRIDSIZE!,
//                    y: (self.currentSwipeStartingPoint.y * PLAYGRIDSIZE!) + PLAYGRIDY0!
//                )
                self.currentSwipeStartingPoint
            )){
                print("BLOB IS COLLIDING")
                return blob
            }
        }
        print("NO COLLIDING BLOB FOUND")
        return nil
    }
    
    func boundaryCheck(blob: Blob) -> Bool {
        //check touch start is not a boundary
        //print("SLICE DIRECTION IS: ", sliceDirection)
        if sliceDirection == "HORIZONTAL" {
            if     (Int(self.currentSwipeStartingPoint.y) != blob.gridY)
                && (Int(self.currentSwipeStartingPoint.y) != blob.gridY + blob.gridHeight){
                return true
            }
        }
        else if sliceDirection == "VERTICAL" {
            if     (Int(self.currentSwipeStartingPoint.x) != blob.gridX)
                && (Int(self.currentSwipeStartingPoint.x) != blob.gridX + blob.gridWidth){
                return true
            }
        }
        print("BOUNDARY CHECK FAILED")
        return false
    }
    
    func deleteFromArray(element: Blob) {
        //creates new array eliminating this element
        self.playScene?.blobs = (self.playScene?.blobs.filter() { $0 !== element })!
    }
    
    func createNewBlob(x: Int, y: Int, width: Int, height: Int, shade: Int){
        print("CREATING NEW BLOB WITH X: ", x, " Y: ", y, " WIDTH: ", width, " HEIGHT: ", height)
        self.playScene?.blobs.append(Blob(x: x, y: y, width: width, height: height, shade: shade, scene: self.playScene!, isMiniLevel: false))
    }
    
    
}
