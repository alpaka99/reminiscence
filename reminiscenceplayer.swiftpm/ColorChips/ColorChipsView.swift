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
    
    let scale = 4.0
    var cellWidth: CGFloat {
        return 90 * scale
    }
    
    var cellHeight: CGFloat{
        return 100 * scale
    }
    
//    var targetMemory: Memory {
//        let mem = memories.filter { $0.id == detailViewID }
//        return mem.first ?? memories[0]
//    }
    
    @State var targetMemory: Memory?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
//                            ForEach(memories.indices, id: \.self) { index in
//                                GeometryReader { geo in
//                                    Colorchip(image: memories[index].image, name: memories[index].name, date: memories[index].date, color: Color(memories[index].color), scale: scale)
//                                        .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
//                                        .position(x: geo.size.width, y: geo.size.height / scale)
//                                        .onTapGesture {
//                                            targetMemory = memories[index]
//                                            showingNotificationView = true
//                                        }
//                                }
//                                .frame(width: 500, height: 800)
//                            }
                            ForEach(memories) { mem in
                                GeometryReader { geo in
                                    Colorchip(image: mem.image, name: mem.name, date: mem.date , color: Color(mem.color), scale: scale)
                                        .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                                        .position(x: geo.size.width, y: geo.size.height / scale)
                                        .onTapGesture {
                                            targetMemory = mem
                                            showingNotificationView = true
                                        }
                                }
                                .frame(width: 500, height: 800)
                            }
                            
                            NavigationLink("", isActive: $showingAddMemoryView) {
                                AddMemoryView()
                            }
                            .frame(width: 500)
                            
                            NavigationLink("", isActive: $showingNotificationView) {
                                    DetailView(memory: targetMemory, memories: _memories)
//                                    DetailView(memory: targetMemory)
//                                    ErrorView()
                            }
                        }
                    }
                    .padding()
                }
            }
            .onChange(of: targetMemory) { _ in
                showingNotificationView = true
            }
            .onChange(of: notificationManager.currentViewId) { viewId in
                getTargetMemory(targetId: viewId!)
                showingNotificationView = true
            }
            .toolbar {
                ToolbarItem() {
                    Button {
                        showingAddMemoryView = true
                    } label: {
                        Text("Add a new memory")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getTargetMemory(targetId: UUID) {
        for mem in memories {
            if mem.id == targetId {
                targetMemory = mem
            }
        }
    }
}


//struct ColorChipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorChipsView(detailViewID: UUID())
//    }
//}
