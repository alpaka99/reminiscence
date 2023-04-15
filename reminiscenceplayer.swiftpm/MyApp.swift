import SwiftUI

@main
struct MyApp: App {
//    @StateObject private var dataController = DataController()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            DNAView()
//            AddMemoryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
