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
    @State var memory: Memory?

    @State var isDeleting = false

    var body: some View {
        VStack {
            if let memory = memory {
                VStack(alignment: .trailing) {
                    Text(String(memory.date.get(.year))+"/\(memory.date.get(.month))/\(memory.date.get(.day))")
                    
                    
                    Image(uiImage: (UIImage(data: memory.image) ?? UIImage(named: "sample_image")!))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .blur(radius: blurAmount)
                    
                    
                    //            TypeWriterView(finalText: "\(memory.date)")
                    TypeWriterView(finalText: memory.name)
                    
//                    NavigationLink("", isActive: $showEditView) {
//                        EditView(memory: memory)
//                    }
                }
                .clipShape(Rectangle())
                .background(Color(memory.color))
                .border(.gray, width: 1)
                //            .shadow(color: .gray, radius: 5, x: 10, y:10)
                //            .background(.white)
            } else {
                Text("Good bye")
            }
            
            
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
        }
        .toolbar {
            ToolbarItem {
                Button {
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
                    dismiss()
                    deleteMemory()
                },
                secondaryButton: .cancel())
        }
        .onAppear {
            getAudios(id: "\(memory!.id)")
            bgmPlayer.player?.stop()
            blurImage()
        }
        .onDisappear {
            soundPlayer.player?.stop()
            bgmPlayer.player?.play()
        }
    }
    
    func deleteMemory() {
        isDeleting = true
        let deletingId = memory!.id
        memory = nil
        for i in 0..<memories.count {
            if deletingId == memories[i].id {
                viewContext.delete(memories[i])
                break
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
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if blurAmount > 0 {
                blurAmount -= 2
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
