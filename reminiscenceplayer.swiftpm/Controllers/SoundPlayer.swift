//
//  SoundPlayer.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import Foundation
import SwiftUI
import AVFoundation

class SoundPlayer: ObservableObject {
    
    var player: AVAudioPlayer?
    
    func play(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName.lowercased(), withExtension:"mp3") else {
            print("\(fileName) not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        player?.stop()
    }
    
    func playRecord(fileName: String) {
        do {
            player = try AVAudioPlayer(contentsOf: getFileURL(fileName: fileName) as URL)
            print("\(fileName) loaded")
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL(fileName: String) -> URL {
        let path = getDocumentDirectory().appendingPathComponent(fileName)
        return path as URL
    }
}
