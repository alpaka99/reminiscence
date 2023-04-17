import SwiftUI

@main
struct MyApp: App {
//    @StateObject private var dataController = DataController()
    
    let persistenceController = PersistenceController.shared
    var soundPlayer = SoundPlayer()
    var bgmPlayer = BGMPlayer()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            DNAView()
//            AddMemoryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(soundPlayer)
                .environmentObject(bgmPlayer)
                .onAppear {
//                    bgmPlayer.play(fileName: "reminiscence")
                }
        }
    }
}
