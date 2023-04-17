//
//  RecorderView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/18.
//

import SwiftUI
import AVKit

struct RecorderView: View {
    @State var soundPlayer = SoundPlayer()
    
    @State private var record = false
    
    // creating instance for recording
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var alert = false
    @State private var soundSamples = [Float](repeating: .zero, count: 10)
    @State private var currentSample = 0
    
    // Fetch Audios...
    @State var audios: [URL] = []
    
    
    let numberOfSamples = 10
    let id: UUID
    
    
    
    var body: some View {
//            VStack {
//                List(self.audios, id: \.self) { i in
//                    Text("\(i.relativeString)")
//                        .onTapGesture {
//                            soundPlayer.play(fileName: i.relativeString)
//                        }
//                }
//                Text(audios[0].relativeString)
//                    .onTapGesture {
//                        soundPlayer.play(fileName: audios[0].relativeString)
//                    }
                
                HStack {
                    Button(action: {
                        // Initialization
                        // store audio in document dicrectory
                        
                        do {
                            
                            if self.record {
                                self.recorder.stop()
                                self.record.toggle()
                                // updating data for every record
                                self.getAudios()
                                return
                            }
                            
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            
                            // name based on audio count
                            let fileName = url.appendingPathComponent("\(id).m4a")
                            
                            let settings = [
                                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                AVSampleRateKey: 12000,
                                AVNumberOfChannelsKey: 1,
                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                            ]
                            
                            self.recorder = try AVAudioRecorder(url: fileName, settings: settings)
                            self.recorder.record()
                            self.recorder.isMeteringEnabled = true
    //                        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                                // 7
                                self.recorder.updateMeters()
                                self.soundSamples[self.currentSample] = self.recorder.averagePower(forChannel: 0)
                                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
                            })
                            self.record.toggle()
                        } catch {
                            print("Cannot initialize audio recorder \(error.localizedDescription)")
                        }
                        
    //                    self.record.toggle()
                    }) {
                        ZStack {
                            
                            
                            if self.record {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 55, height: 55)
                                
                                Circle()
                                    .stroke(Color.red, lineWidth: 6)
                                    .overlay {
                                        Image(systemName: "pause")
                                            .tint(.white)
                                    }
                                    .frame(width: 70, height: 70)
                            } else {
                                Circle()
                                    .fill(Color.red)
                                    .overlay {
                                        Image(systemName: "mic")
                                            .tint(.white)
                                    }
                                    .frame(width: 70, height: 70)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            // 4
                            ForEach(soundSamples, id: \.self) { level in
                                BarView(value: self.normalizeSoundLevel(level: level))
                            }
                        }
                    }
                }
//                .padding(.vertical, 25)
//            }
//        .alert(isPresented: self.$alert) {
//            Alert(title: Text("Error"), message: Text("Enable Access"))
//        }
        .onAppear {
            do {
                self.session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord)
                
                // requesting permission
                // for this wew require microphone usage description in info.plist
//                self.session.requestRecordPermission{(status) in
//                    if !status {
//                        self.alert.toggle()
//                    }
//                }
                self.getAudios()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAudios() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // fetch all data from document directory
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            // remove all data when updated with new ones
            self.audios.removeAll()
            
            for i in result {
                self.audios.append(i)
            }
            
        } catch {
            print("Cannot get audio \(error.localizedDescription)")
            
        }
    }
    
    func deleteRecord(offset: IndexSet) {
        
    }
    
    func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(id: UUID())
    }
}


