//
//  SongViewController.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AVFoundation
import MediaPlayer
import UIKit

class SongViewController: UIViewController {

    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var albumImageView: UIImageView!

    var exportPath: String = ""
    var startTime: Float = 0.00
    let songProcessor = SongProcessor.sharedInstance
    var exporter: SongExporter?
    var art: UIImage?
    
    var songURL: URL? {
        didSet {
            songProcessor.iTunesFilePlayer?.stop()

            let fail = {
                let alert = UIAlertController(title: "Couldn't load song", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }

            guard let newSong = songURL else {
                return fail()
            }

            DispatchQueue.global(qos: .default).async {
                let docDirs: [NSString] = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                              .userDomainMask,
                                                                              true) as [NSString]
                let docDir = docDirs[0]
                let tmp = docDir.appendingPathComponent("exported") as NSString
                self.exportPath = tmp.appendingPathExtension("caf")!

                self.exporter = SongExporter(exportPath: self.exportPath)
                self.exporter?.exportSong(newSong, completion: { success in
                    DispatchQueue.main.async {
                        if success {
                            self.loadSong()
                            self.playButton.isUserInteractionEnabled = true
                            self.playButton.setTitle("Stop", for: UIControl.State())
                            self.songProcessor.iTunesPlaying = true
                        } else {
                            fail()
                        }

                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.setTitle("Loading", for: UIControl.State())
        playButton.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(barButton:)))
        
        self.albumImageView.image = self.art
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func play(_ sender: UIButton) {
        songProcessor.iTunesPlaying = !songProcessor.iTunesPlaying
        playButton.setTitle(songProcessor.iTunesPlaying ? "Stop" : "Play", for: UIControl.State())
    }

    
    func loadSong() {

        let url = URL(fileURLWithPath: exportPath)

        if FileManager.default.fileExists(atPath: url.path) == false {
            print("exportPath: \(exportPath)")
            print("File does not exist.")
            return
        }

        do {
            let exportedFile = try AKAudioFile(forReading:url)
            if songProcessor.iTunesFilePlayer == nil {
                songProcessor.iTunesFilePlayer = AKPlayer(audioFile: exportedFile)
                songProcessor.iTunesFilePlayer! >>> songProcessor.playerMixer
            }
            guard let iTunesFilePlayer = songProcessor.iTunesFilePlayer else { return }

            iTunesFilePlayer.load(audioFile: exportedFile)
        } catch {
            print(error)
        }
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