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
    @State var memory: Memory?
    @State var isDeleting = false
    
//    var memories: FetchedResults<Memory>
    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: true)]) var memories: FetchedResults<Memory>

    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.blue, .white],
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            
            VStack {
                if let memory = memory {
                    VStack(alignment: .trailing, spacing: 10) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(memory.color))
                            .frame(width:300, height: 300)
                            .overlay {
                                Image(uiImage: (UIImage(data: memory.image) ?? UIImage(named: "sample_image")!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .blur(radius: blurAmount)
                            }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(String(memory.date.get(.year))+"/\(memory.date.get(.month))/\(memory.date.get(.day))")
                                .font(.title2)
                            TypeWriterView(finalText: memory.name)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    .clipShape(Rectangle())
                    .background(Color(memory.color))
                } else {
                    Text("Good bye")
                }
                
                
                if audios.isEmpty == false {
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
                            .background(.white)
                        }
                    }
                }
            }
        }
        .background()
        .navigationViewStyle(StackNavigationViewStyle())
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
        
        if audios.isEmpty == false {
            do {
                try FileManager.default.removeItem(at: audios[0])
                print("erased")
            } catch {
                print("Erase file error \(error.localizedDescription)")
            }
        } else {
            print("No audio file")
        }
        
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
        
    }
    
    func blurImage() {
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
