//
//  AudioRecordView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI
import AVFoundation

struct AudioRecordView: View {
    var recordingSession = AVAudioSession.sharedInstance()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AudioRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordView()
    }
}
