//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Itua Ijagbone on 7/7/15.
//  Copyright (c) 2015 Innobui. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer = AVAudioPlayer()
    var recordedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var restartAudioVal: NSTimeInterval = 0
    
    /**
    Helper function to setup audio file given the name of the file and file extension
    */
    func setupAudioPlayerWithFile(file: NSString, type: NSString) -> AVAudioPlayer {
        var audioPath = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var audioUrl = NSURL.fileURLWithPath(audioPath!)
        
        var audioError: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: audioUrl, error: &audioError)
        audioPlayer?.enableRate = true
        return audioPlayer!
    }
    
    /**
    Helper function to setup audio file given the NSURL object
    */
    func setupAudioPlayerWithNSURL(recordedAudioUrl: NSURL) -> AVAudioPlayer {
        var audioError: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudioUrl, error: &audioError)
        audioPlayer?.enableRate = true
        return audioPlayer!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = self.setupAudioPlayerWithNSURL(recordedAudio.filePathUrl)
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    UIKit Button Action to play slow sound
    */
    @IBAction func slowSoundAction(sender: UIButton) {
        stopAllAudio()
        audioPlayer.currentTime = restartAudioVal
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    /**
    UIKit Button Action to play fast sound
    */
    @IBAction func fastSoundAction(sender: UIButton) {
        stopAllAudio()
        audioPlayer.currentTime = restartAudioVal
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    /**
    UIKit Button Action to play chipmunk sound
    */
    @IBAction func chipmunkSoundAction(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /**
    UIKit Button Action to play darth vader sound
    */
    @IBAction func darthVaderSoundAction(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /**
    UIKit Button Action to stop all sounds
    */
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    /**
    Helper function to play type of sound given particular pitch
    */
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    /**
    Helper function to stop all sound
    */
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
