//
//  ViewController.swift
//  SensorBabyDemo
//
//  Created by Phillip Eismark on 12/04/2019.
//  Copyright © 2019 Phillip Eismark. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let motion = CMMotionManager()
    var queue = OperationQueue()
    var data = CMAccelerometerData()
    var græd: AVAudioPlayer?
    var glad: AVAudioPlayer?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = #imageLiteral(resourceName: "gladbabyy")
        startAccelerometers()
        
        do {
            græd = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Græd", ofType: ".wav")!))
        }
        catch {
            print(error)
        }
        do {
            glad = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Glad", ofType: ".wav")!))
        }
        catch {
            print(error)
        }
    }

    func startAccelerometers() {
        print("in start accelerometers")
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            
            print("Accelerometer is available")
            self.motion.startAccelerometerUpdates()
            self.motion.accelerometerUpdateInterval = 0.1
            print("Started Accelerometer updates")
            
            motion.startDeviceMotionUpdates(to: queue) { (motion, error) in
                print(motion?.attitude.roll ?? 0.0)
                
                    self.playSound(roll: motion?.attitude.roll ?? 0.0)
                
        }
    }
}
    
    
    
    func playSound(roll: Double){
        
        if roll < -3 {
            
            DispatchQueue.main.async {
                self.imageView.image = #imageLiteral(resourceName: "kedBaby")
            }
        
            do {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
//              græd = try AVAudioPlayer(contentsOf: urlGræd, fileTypeHint: AVFileType.mp3.rawValue)
                græd!.play()
        
                } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            
                }
        }
            
        else if roll > 0 {
            
            DispatchQueue.main.async {
                self.imageView.image = #imageLiteral(resourceName: "gladbaby")
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                glad!.play()
            
                } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
    }
}
        
    
   /* func setAudio() {
    
        guard let urlGræd = Bundle.main.url(forResource: "Græd", withExtension: ".wav") else {
            print("Græd sound not found")
            return
        }
        
        guard let urlGlad = Bundle.main.url(forResource: "Glad", withExtension: ".wav") else {
            print("url not found")
            return
        }
        
    }*/
}
