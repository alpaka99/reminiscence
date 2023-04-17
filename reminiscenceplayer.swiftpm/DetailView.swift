//
//  DetailView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var bgmPlayer: BGMPlayer
    @EnvironmentObject var soundPlayer: SoundPlayer

    @State private var blurAmount: Double = 20.0
    @State private var audios: [URL] = []
    @State private var isPlaying = false
    @State private var showEditView = false
    @State private var showAlert = false
    
    var memories: FetchedResults<Memory>
    let memory: Memory
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }()

    var body: some View {
        VStack {
            Image(uiImage: (UIImage(data: memory.image) ?? UIImage(named: "sample_image")!))
                .resizable()
                .scaledToFit()
                .blur(radius: blurAmount)
            
//            TypeWriterView(finalText: "\(memory.date)")
            TypeWriterView(finalText: memory.name)
            
            // ???
//            List(self.audios, id: \.self) { i in
//                    Text("\(i.relativeString)")
//                    .onTapGesture {
//                        soundPlayer.playRecord(fileName: i.relativeString)
//                    }
//            }
            
            HStack {
                Button {
                    if isPlaying {
                        soundPlayer.stop()
                    } else {
                        for i in audios {
                            soundPlayer.playRecord(fileName: i.relativeString)
                        }
                    }
                    isPlaying.toggle()
                } label: {
                    if isPlaying {
                        HStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 75, height: 75)
                                .overlay {
                                    Image(systemName: "pause")
                                        .tint(.white)
                                }
                            Text("Playing reminiscence")
                        }
                    } else {
                        HStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 75, height: 75)
                                .overlay {
                                    Image(systemName: "recordingtape")
                                        .tint(.blue)
                                }
                            Text("Play this reminiscence")
                        }
                    }
                }
                
                NavigationLink("", isActive: $showEditView) {
                    EditView()
                }
                
            }
        }
        .background(Color(memory.color))
        .toolbar {
            ToolbarItem {
                Button {
                    showEditView = true
                } label: {
                    Text("Edit")
                }
            }
            
            ToolbarItem {
                Button {
//                    deleteMemory()
                    showAlert.toggle()
                } label: {
                    Text("Delete")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("Do you really want to delete this memory?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteMemory()
                },
                secondaryButton: .cancel())
        }
        .onAppear {
            getAudios(id: "\(memory.id)")
            bgmPlayer.player?.stop()
            blurImage()
        }
        .onDisappear {
            soundPlayer.player?.stop()
            bgmPlayer.player?.play()
        }
    }
    
    func deleteMemory() {
//        index.map { memories[$0] }.forEach(viewContext.delete)
        
//        indexSet.map { memories[$0] }.forEach(viewContext.delete)
        for i in 0..<memories.count {
            if memory.id == memories[i].id {
                viewContext.delete(memories[i])
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription)")
        }
        
//        dismiss()
    }
    
    func blurImage() {
        blurAmount = Double(memory.name.count)
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if blurAmount > 0 {
                blurAmount -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    func getAudios(id: String) {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // fetch all data from document directory
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            // remove all data when updated with new ones
            self.audios.removeAll()
            
            for i in result {
                if i.relativeString.hasPrefix(id) {
                    self.audios.append(i)
                }
            }
            
//            print("This is audios \n\n\n")
//            print(audios.count)
            
        } catch {
            print("Cannot get audio \(error.localizedDescription)")
            
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(memory: Memory)
//    }
//}
