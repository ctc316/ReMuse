//
//  SongExporter.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AVFoundation
import MediaPlayer
import UIKit

class SongExporter {

    var exportPath: String = ""
    var isReadyToPlay: Bool = true

    init(exportPath: String) {
        self.exportPath = exportPath
    }

    func exportSong(_ url: URL, completion: ((Bool) -> Void)? = nil) {

        isReadyToPlay = false
    
        let songAsset = AVURLAsset(url: url, options: nil)

        var assetError: NSError?

        do {
            let assetReader = try AVAssetReader(asset: songAsset)

            // Create an asset reader ouput and add it to the reader.
            let assetReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: songAsset.tracks, audioSettings: nil)

            if !assetReader.canAdd(assetReaderOutput) {
                print("Can't add reader output...die!")
                completion?(false)
            } else {
                assetReader.add(assetReaderOutput)
            }

            // If a file already exists at the export path, remove it.
            if FileManager.default.fileExists(atPath: exportPath) {
                print("Deleting said file.")
                do {
                    try FileManager.default.removeItem(atPath: exportPath)
                } catch {
                    print(error)
                    completion?(false)
                }
            }

            // Create an asset writer with the export path.
            let exportURL = URL(fileURLWithPath: exportPath)
            let assetWriter: AVAssetWriter!
            do {
                assetWriter = try AVAssetWriter(outputURL: exportURL, fileType: AVFileType.caf)
            } catch let error as NSError {
                assetError = error
                assetWriter = nil
                completion?(false)
            }

            if let error = assetError {
                print("Error: \(error)")
                completion?(false)
                return
            }

            // Define the format settings for the asset writer.  Defined in AVAudioSettings.h

            // memset(&channelLayout, 0, sizeof(AudioChannelLayout))
            let outputSettings = [ AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32),
                                   AVSampleRateKey: NSNumber(value: 44_100.0 as Float),
                                   AVNumberOfChannelsKey: NSNumber(value: 2 as UInt32),
                                   AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
                                   AVLinearPCMIsNonInterleaved: NSNumber(value: false as Bool),
                                   AVLinearPCMIsFloatKey: NSNumber(value: false as Bool),
                                   AVLinearPCMIsBigEndianKey: NSNumber(value: false as Bool)
            ]

            // Create a writer input to encode and write samples in this format.
            let assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio,
                                                      outputSettings: outputSettings)

            // Add the input to the writer.
            if assetWriter.canAdd(assetWriterInput) {
                assetWriter.add(assetWriterInput)
            } else {
                print("cant add asset writer input...die!")
                completion?(false)
                return
            }

            // Change this property to YES if you want to start using the data immediately.
            assetWriterInput.expectsMediaDataInRealTime = false

            // Start reading from the reader and writing to the writer.
            assetWriter.startWriting()
            assetReader.startReading()

            // Set the session start time.
            let soundTrack = songAsset.tracks[0]
            let cmtStartTime: CMTime = CMTimeMake(value: 0, timescale: soundTrack.naturalTimeScale)
            assetWriter.startSession(atSourceTime: cmtStartTime)

            // Variable to store the converted bytes.
            var convertedByteCount: Int = 0
            var buffers: Float = 0

            // Create a queue to which the writing block with be submitted.
            let mediaInputQueue: DispatchQueue = DispatchQueue(label: "mediaInputQueue", attributes: [])

            // Instruct the writer input to invoke a block repeatedly, at its convenience, in
            // order to gather media data for writing to the output.
            assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue, using: {

                // While the writer input can accept more samples, keep appending its buffers
                // with buffers read from the reader output.
                while assetWriterInput.isReadyForMoreMediaData {

                    if let nextBuffer = assetReaderOutput.copyNextSampleBuffer() {
                        assetWriterInput.append(nextBuffer)
                        // Increment byte count.
                        convertedByteCount += CMSampleBufferGetTotalSampleSize(nextBuffer)
                        buffers += 0.000_2

                    } else {
                        // All done
                        assetWriterInput.markAsFinished()
                        assetWriter.finishWriting {
                            self.isReadyToPlay = true
                            completion?(true)
                        }
                        assetReader.cancelReading()
                        break
                    }
                    // Core Foundation objects automatically memory managed in Swift
                    // CFRelease(nextBuffer)
                }
            })

        } catch let error as NSError {
            assetError = error
            completion?(false)
            print("Initializing assetReader Failed")
        }

    }
}
