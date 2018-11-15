//
//  Filters.swift
//  ReMuse
//
//  Created by ctc316 on 2018/11/14.
//  Copyright © 2018年 ctc316. All rights reserved.
//

import Foundation
import UIKit


public class Filters{
    
    
    public static func getItems() -> [SwiftMultiSelectItem] {
        var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
//        ThemeColors.amethystColor,
//        ThemeColors.asbestosColor,
//        ThemeColors.sunflowerColor,
//        ThemeColors.peterRiverColor,
//        ThemeColors.pomegranateColor,
//        ThemeColors.pumpkinColor,
        
        items.append(SwiftMultiSelectItem(
            row         : 0,
            title       : "Delay",
            initials    : "Delay",
            description : "",
            image       : UIImage(),
            imageURL    : "",
            color       : ThemeColors.amethystColor,
            userInfo    : []
            )
        )
        
        items.append(SwiftMultiSelectItem(
            row         : 1,
            title       : "Moog Ladder",
            initials    : "Moog",
            description : "",
            image       : UIImage(),
            imageURL    : "",
            color       : ThemeColors.pumpkinColor,
            userInfo    : []
            )
        )
        
        items.append(SwiftMultiSelectItem(
            row         : 2,
            title       : "Costello Reverb",
            initials    : "Reverb",
            description : "",
            image       : UIImage(),
            imageURL    : "",
            color       : ThemeColors.asbestosColor,
            userInfo    : []
            )
        )
        
        items.append(SwiftMultiSelectItem(
            row         : 3,
            title       : "Pitch Shifter",
            initials    : "Pitch",
            description : "",
            image       : UIImage(),
            imageURL    : "",
            color       : ThemeColors.sunflowerColor,
            userInfo    : []
            )
        )
        
        items.append(SwiftMultiSelectItem(
            row         : 4,
            title       : "Bit Crusher",
            initials    : "Bit",
            description : "",
            image       : UIImage(),
            imageURL    : "",
            color       : ThemeColors.peterRiverColor,
            userInfo    : []
            )
        )
        
        return items
    }
    
    
    public static func filter(index: Int, on: Bool){
        let songProcessor = SongProcessor.sharedInstance
        switch index {
        case 0:
            if on {
                songProcessor.variableDelay.time = 0.8
                songProcessor.variableDelay.feedback = 0.5
                songProcessor.delayMixer.balance = 1
            } else {
                songProcessor.delayMixer.balance = 0
            }
        case 1:
            if on {
                songProcessor.moogLadder.cutoffFrequency = 2000
                songProcessor.moogLadder.resonance = 0.7
                songProcessor.filterMixer.balance = 1
            } else {
                songProcessor.filterMixer.balance = 0
            }
        case 2:
            if on {
                songProcessor.reverb.feedback = 0.5
                songProcessor.reverbMixer.balance = 1
            } else {
                songProcessor.reverbMixer.balance = 0
            }
        case 3:
            let songProcessor = SongProcessor.sharedInstance
            if on {
                songProcessor.pitchShifter.shift = 15
                songProcessor.pitchMixer.balance = 1
            } else {
                songProcessor.pitchMixer.balance = 0
            }
        case 4:
            let songProcessor = SongProcessor.sharedInstance
            if on {
                songProcessor.bitCrusher.bitDepth = 20
                songProcessor.bitCrusher.sampleRate = 4000
                songProcessor.bitCrushMixer.balance = 1
            } else {
                songProcessor.bitCrushMixer.balance = 0
            }
        default:
            ()
        }
    }
}
