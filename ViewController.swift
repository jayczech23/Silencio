//
//  ViewController.swift
//  Silencio
//
//  Created by Jordan Cech on 9/24/16.
//  Copyright © 2016 Jordan Cech. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
   
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    var testSound: AVAudioPlayer!
    
    var soundToleranceValue: Float = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "test", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            
            try testSound = AVAudioPlayer(contentsOf: soundURL)
            testSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
       
    }
    
    @IBAction func playBtnPressed(_ sender: AnyObject) {
        playSound()
        stopBtn.isHidden = false
        
    }
    
    func playSound() {
        
        if testSound.isPlaying {
            testSound.stop()
        }
        
        testSound.play()
        testSound.numberOfLoops = 100
        okayBtn.isHidden = false
        playBtn.isHidden = true
    }
    
    
    @IBAction func okayBtnPressed(_ sender: AnyObject) {
    
        //okayBtn.isHidden = true
        //playBtn.isHidden = false
        testSound.stop()
        
        soundToleranceValue = (slider.value * 10) / 2
        slider.isHidden = true
        
        // print to logs the value of the tolerance level.
        print("Your tolerance level is: \(soundToleranceValue)")
    }
    
    @IBAction func sliderModified(_ sender: AnyObject) {
        
        testSound.volume = slider.value
        
    }
    
    @IBAction func stopBtnPressed(_ sender: AnyObject) {
        
        testSound.stop()
        playBtn.isHidden = false
        stopBtn.isHidden = true
        
    }
    
    

}

