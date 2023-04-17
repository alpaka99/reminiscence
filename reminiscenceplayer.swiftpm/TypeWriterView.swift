//
//  TypeWriterView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI

struct TypeWriterView: View {
    @State private var text = ""
    var index = 0
    let finalText: String
    
    @EnvironmentObject var soundPlayer: SoundPlayer
    
    var body: some View {
        Text(text)
            .onAppear(perform: typeWrite)
            .onTapGesture {
                typeWrite()
            }
            .onDisappear {
                
            }
    }
    
    func typeWrite() {
        text = ""
        var index = 0
        
        let charArray = finalText.characterArray
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            let letter = String(charArray[index])
            text += letter
            switch(letter) {
            case ".":
                soundPlayer.play(fileName: "dot")
            case "!":
                soundPlayer.play(fileName: "exclamation")
            case "?":
                soundPlayer.play(fileName: "question")
            case ",":
                soundPlayer.play(fileName: "rest")
            case " ":
                print(" ")
            default:
                soundPlayer.play(fileName: letter)
            }
            index += 1
            
            if index >= charArray.count {
                timer.invalidate()
            }
        }
    }
}

struct TypeWriterView_Previews: PreviewProvider {
    static var previews: some View {
        TypeWriterView(finalText: "Type this example string")
    }
}

extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self {
            characterArray.append(character)
        }
        return characterArray
    }
}

extension TypeWriterView {
    func stopSound() {
        self.soundPlayer.player?.stop()
    }
}


