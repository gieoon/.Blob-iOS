//
//  AudioManager.swift
//  Blob
//
//  Created by gieoon on 2018/02/11.
//  Copyright © 2018 shunkagaya. All rights reserved.
//
//import AudioToolbox
import AVFoundation

class AudioManager {
    //final
    let AUDIOCHANGERATE: Float = 0.01
    let AUDIOCHANGEDURATION: TimeInterval = 5.0
    
    static let _audioInstance = AudioManager()
    
    var playerMenu, playerTransition, playerPlay, playerEffect1, playerEffect2, playerEffect3: AVAudioPlayer?
    
    let menuAudioUrl = Bundle.main.url(forResource: "menu_background_music", withExtension: "mp3", subdirectory: "sounds/menu_fx")!
    let playAudioUrl = Bundle.main.url(forResource: "background_track3", withExtension: "mp3", subdirectory: "sounds")!
    let transitionAudioUrl = Bundle.main.url(forResource: "transition_level", withExtension: "mp3", subdirectory: "sounds")!
    
    
    let buttonClickUrl = Bundle.main.url(forResource: "click_fx", withExtension: "wav", subdirectory: "sounds/menu_fx")!
    let buttonReturnUrl = Bundle.main.url(forResource: "click_return_fx", withExtension: "wav", subdirectory: "sounds/menu_fx")!
    let selectLevelUrl = Bundle.main.url(forResource: "select_fx", withExtension: "wav", subdirectory: "sounds/menu_fx")!
    
    let goalCompleteArray = [
        "goal_complete_2", "goal_complete_3", "goal_complete_4", "goal_complete"
    ]
    
    
    
    func loadAudio(){
        //init a dictionary of instances?
        //print(Bundle.main.paths(forResourcesOfType: audio, inDirectory: "resources"))
        do{
            playerMenu = try AVAudioPlayer(contentsOf: menuAudioUrl)
            playerTransition = try AVAudioPlayer(contentsOf: transitionAudioUrl)
            playerPlay = try AVAudioPlayer(contentsOf: playAudioUrl)
            //guard player = player else { return }
            playerMenu?.prepareToPlay()
            playerTransition?.prepareToPlay()
            playerPlay?.prepareToPlay()
            
        }catch is NSError {
            print("NO AUDIO PLAYER IS AVAILABLE")
            return
        }
    }
    
    //Deprecated, Not In Use
    func getFreeAudioFXPlayer() -> AVAudioPlayer? {
        let players = [playerEffect1, playerEffect2, playerEffect3]
        for player in players {
            if player == nil {
                return player
            }
        }
        print("NO AUDIO PLAYER IS AVAILABLE")
        return nil
    }
    
    func getAudioFXFromArrayAndPlay(array: [String]){
        let length = array.count
        //get a random integer in the length
        let randIndex = randRange(lower: 0, upper: length)
        //turn it into a URL
        let strUrl = goalCompleteArray[randIndex]
        let soundUrl = Bundle.main.url(forResource: strUrl, withExtension: "wav", subdirectory: "sounds")!
        //play that audio
        playAudioFX(url: soundUrl)
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    //TODO, make the audio slowly grow louder
    func playAudioFX(url: URL){
        do {
            //if var player = getFreeAudioFXPlayer(){
                let player = try AVAudioPlayer(contentsOf: url)
                //guard player = player else { return }
                player.prepareToPlay()
                player.numberOfLoops = 0
                player.play()
                print("AUDIOFX was played")
            //}
        } catch let error as NSError {
            print("ERROR CAUGHT: ", error.description)
        }
    }
    
//    func fadeIn(player: AVAudioPlayer){
//        if(player.volume < 1 - AUDIOCHANGERATE){
//            player.volume += AUDIOCHANGERATE
//            print("Audio changed volume")
//        }
//        else {
//            player.volume = 1
//            print("AUdio volume fade in complete")
//        }
//    }
    //when moving into a new scene, call background music for new scene with this
    func fadeInBackgroundAudio(player : AVAudioPlayer){
        player.numberOfLoops = -1
        player.volume = 0.0
        var soundQueue = OperationQueue()
        soundQueue.qualityOfService = QualityOfService.background
        soundQueue.addOperation {
            player.play()
        }
        //TEMPORARILY REMOVING FOR TESTING
        //player.play()
        player.setVolume(1.0, fadeDuration: AUDIOCHANGEDURATION)
    }
    
    //called when moving to new scene, fade out sound for current scene
    func fadeOut(player: AVAudioPlayer){
//        if player.volume > 0 + AUDIOCHANGERATE {
//            player.volume -= AUDIOCHANGERATE
//        }
//        else {
//            player.volume = 0
//            player.s
//        }
        //turns out there's a helper function in the API...
        player.setVolume(0.0, fadeDuration: AUDIOCHANGEDURATION)
//        let timer = Timer.init(timeInterval: AUDIOCHANGEDURATION, repeats: false, block: {
//            _ in player.stop()
//            print("Player was stopped")
//        })
        //make the sound fade out with each update
        //test again
        
    }
    
    class var audioInstance : AudioManager {
        return _audioInstance
    }
}



