//
//  ReminiscenceView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/15.
//

import SwiftUI
import CoreData

struct DNAView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: true)]) var memories: FetchedResults<Memory>
    
    @State private var showingAddMemoryView = false
    @State private var showingNotificationView = false
    @State private var detailViewID: UUID?
    var memory: Memory {
        let mem = memories.filter { $0.id == detailViewID }
        return mem.first ?? memories[0]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { fullView in
                    List {
                        ForEach(memories) { memory in
                            GeometryReader { geo in
                                NavigationLink(" \(memory.name)") {
                                    DetailView(memory: memory, memories: _memories)
                                }
                                .font(.title)
                                .frame(maxWidth: fullView.size.width)
                                .background(Color(memory.color as UIColor))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
//                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY) / 5, axis: (x: 0, y: 1, z: 0))
                            }
                            .frame(height: 40)
                        }
                        .onDelete(perform: deleteMemory)
                        .onChange(of: notificationManager.currentViewId) { viewId in
                            detailViewID = viewId
                            showingNotificationView = true
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.clear)
//                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                    }
                }
                NavigationLink("", isActive: $showingAddMemoryView) {
                    AddMemoryView()
                }
//                NavigationLink("", isActive: $showingNotificationView) {
//                    DetailView(memories: memories,memory: memory)
//                }
            }
            .toolbar {
                ToolbarItem() {
                    Button {
                        showingAddMemoryView = true
                    } label: {
                        Text("Add a new memory")
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
