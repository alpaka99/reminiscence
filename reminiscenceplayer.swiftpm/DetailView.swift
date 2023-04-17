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
            
            
        }
        .background(Color(memory.color))
        .toolbar {
            ToolbarItem {
                Button("Delete memory") {
                    deleteMemory()
                }
            }
        }
        .onAppear {
            bgmPlayer.player?.stop()
            blurImage()
        }
        .onDisappear {
//            soundPlayer.player?.stop()
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
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(memory: Memory)
//    }
//}
