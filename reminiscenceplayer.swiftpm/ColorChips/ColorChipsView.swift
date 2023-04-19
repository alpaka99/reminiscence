//
//  ColorChipsView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/19.
//
import Foundation
import SwiftUI

struct ColorChipsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var notificationManager: NotificationManager
    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: true)]) var memories: FetchedResults<Memory>
    
    @State var showingAddMemoryView = false
    @State var showingNotificationView = false
    @State var detailViewID: UUID?
    
    var memory: Memory {
        let mem = memories.filter { $0.id == detailViewID }
        return mem.first ?? memories[0]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 150) {
                        ForEach(memories, id: \.self) { mem in
                            GeometryReader { geo in
                                Colorchip(image: mem.image, name: mem.name, date: mem.date, color: Color(mem.color), scale: 2)
                                    .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                    .onTapGesture {
                                        detailViewID = mem.id
                                        showingNotificationView = true
                                    }
                            }
                        }
                        
                        NavigationLink("", isActive: $showingAddMemoryView) {
                            AddMemoryView()
                        }
                        NavigationLink("", isActive: $showingNotificationView) {
                            DetailView(memories: memories,memory: memory)
                        }
                    }
                }
                .onChange(of: notificationManager.currentViewId) { viewId in
                    detailViewID = viewId
                    showingNotificationView = true
                }
                
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
        .ignoresSafeArea(.all)
    }
}


//struct ColorChipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorChipsView(detailViewID: UUID())
//    }
//}
