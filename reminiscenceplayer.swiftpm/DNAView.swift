//
//  ReminiscenceView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/15.
//

import SwiftUI

struct DNAView: View {
//    @FetchRequest(sortDescriptors: []) var memories: FetchedResults<Memory>
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Memory.entity(), sortDescriptors: []) private var memories: FetchedResults<Memory>
    @State private var showingAddMemoryView = false
    
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { fullView in
                    List {
                        ForEach(memories) { memory in
                            GeometryReader { geo in
//                                Text("Row #\(memory.name)")
                                NavigationLink("Row #\(memory.name)") {
                                    DetailView(memory: memory)
                                }
                                .font(.title)
                                .frame(maxWidth: fullView.size.width)
                                .background(Color(memory.color as UIColor))
                                .clipShape(Capsule())
                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            }
                            .frame(height: 50)
                        }
                        .onDelete(perform: deleteMemory)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.clear)
                    }
                }
                
                NavigationLink("", isActive: $showingAddMemoryView) {
                    AddMemoryView()
                }
            }
            .toolbar {
                ToolbarItem() {
                    Button {
                        showingAddMemoryView = true
                    } label: {
                        Text("Add new memory")
                    }
                }
            }
        }
    }
    
//    func addNewMemory() {
//        let newMemory = Memory(context: viewContext)
//        newMemory.name = "memory #\(memories.count+1)"
//        newMemory.id = UUID()
//        newMemory.image = "sampleImage"
//        
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError.localizedDescription)")
//        }
//    }
    
    func deleteMemory(index: IndexSet) {
        withAnimation {
            index.map { memories[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription)")
            }
        }
    }
}

struct DNAView_Previews: PreviewProvider {
    static var previews: some View {
        DNAView()
    }
}
