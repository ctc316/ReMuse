//
//  BitCrusherViewController.swift
//  SongProcessor
//
//  Created by Elizabeth Simonian, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

class VolumeBoosterViewController: UIViewController {
    
    @IBOutlet private var volumeSlider: AKSlider!

    
    let songProcessor = SongProcessor.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeSlider.range = 0 ... 10.0
        
        volumeSlider.value = songProcessor.playerBooster.gain
        volumeSlider.callback = updateVolume
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateVolume(value: Double) {
        songProcessor.playerBooster.gain = value
    }
    
    @objc func share(barButton: UIBarButtonItem) {
        renderAndShare { docController in
            guard let canOpen = docController?.presentOpenInMenu(from: barButton, animated: true) else { return }
            if !canOpen {
                self.present(self.alertForShareFail(), animated: true, completion: nil)
            }
        }
    }
    
}
