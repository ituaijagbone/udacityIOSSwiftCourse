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
    var slowAudio = AVAudioPlayer()
    var recordedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var restartAudioVal: NSTimeInterval = 0
    
    func setupAudioPlayerWithFile(file: NSString, type: NSString) -> AVAudioPlayer {
        var audioPath = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var audioUrl = NSURL.fileURLWithPath(audioPath!)
        
        var audioError: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: audioUrl, error: &audioError)
        audioPlayer?.enableRate = true
        return audioPlayer!
    }
    
    func setupAudioPlayerWithNSURL(recordedAudioUrl: NSURL) -> AVAudioPlayer {
        var audioError: NSError?
        
        var audioPlayer: AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudioUrl, error: &audioError)
        audioPlayer?.enableRate = true
        return audioPlayer!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slowAudio = self.setupAudioPlayerWithNSURL(recordedAudio.filePathUrl)
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func slowSoundAction(sender: UIButton) {
        stopAllAudio()
        slowAudio.currentTime = restartAudioVal
        slowAudio.rate = 0.5
        slowAudio.play()
    }
    
    @IBAction func fastSoundAction(sender: UIButton) {
        stopAllAudio()
        slowAudio.currentTime = restartAudioVal
        slowAudio.rate = 1.5
        slowAudio.play()
    }
    
    @IBAction func chipmunkSoundAction(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderSoundAction(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
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
    
    func stopAllAudio() {
        slowAudio.stop()
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
