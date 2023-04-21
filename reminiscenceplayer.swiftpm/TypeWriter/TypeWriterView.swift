//
//  TypeWriterView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI

struct TypeWriterView: View {
    @EnvironmentObject var soundPlayer: SoundPlayer
    
    @State private var text = ""
    
    var index = 0
    let finalText: String
    
    var body: some View {
        Text(text)
//            .font(Font.custom("HelveticaNeue-Bold", size: 15))
            .font(.title3)
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



