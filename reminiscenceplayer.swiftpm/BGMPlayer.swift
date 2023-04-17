//
//  BGMPlayer.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import Foundation
import SwiftUI
import AVFoundation

class BGMPlayer: ObservableObject {
//    static let soundPlayer = SoundSetting()
    
    var player: AVAudioPlayer?
    
    func play(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName.lowercased(), withExtension:"mp3") else {
            print("\(fileName) not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        player?.stop()
    }
}
