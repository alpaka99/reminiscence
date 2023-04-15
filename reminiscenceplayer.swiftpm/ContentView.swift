import SwiftUI
import AVFoundation

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .onTapGesture {
                    print("Tapped")
                }
        }
    }
}
