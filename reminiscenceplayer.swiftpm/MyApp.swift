import SwiftUI

@main
struct MyApp: App {
    let notificationManager = NotificationManager()

        init() {
            UNUserNotificationCenter.current().delegate = notificationManager
        }
    
    
    let persistenceController = PersistenceController.shared
    var soundPlayer = SoundPlayer()
    var bgmPlayer = BGMPlayer()
    
    var body: some Scene {
        WindowGroup {
//            DNAView()
            ColorChipsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(soundPlayer)
                .environmentObject(bgmPlayer)
                .environmentObject(notificationManager)
                .onAppear {
//                    bgmPlayer.play(fileName: "reminiscence")
                }
        }
    }
}
