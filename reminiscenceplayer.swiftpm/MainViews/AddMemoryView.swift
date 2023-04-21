//
//  AddMemory.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/15.
//

import SwiftUI
import UserNotifications
import CoreData

struct AddMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    @FetchRequest(entity: Memory.entity(), sortDescriptors: []) private var memories: FetchedResults<Memory>
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var averageUIColor: UIColor?
    @State private var text = ""
    @State private var pickedColor: Color = Color.clear
    @State private var date: Date = Date()
    
    let id = UUID()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("What's the name of this memory?", text: $text)
                }
                
//                if let loadedImage = image {
                Section("Visual Reminiscence") {
                    VStack(alignment: .center) {
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFit()
                            
                            
                            
                            Button("Change image") {
                                showImagePicker = true
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.secondary)
                                
                                Text("Tap if you have picture of \n\"\(text)\"")
                                    .tint(.white)
                            }
                            .onTapGesture {
                                showImagePicker = true
                            }
                        }
                    }
                    .frame(width: 200, height: 200)
                        
                        // dominat color & color picker
                        Rectangle()
                            .fill((averageUIColor != nil) ? Color(averageUIColor!) : .clear)
                            .frame(width: 200, height: 200)
                            .overlay {
                                ColorPicker("What color represents \n\"\(text)\"?", selection: $pickedColor)
                                    .onChange(of: pickedColor) { _ in
                                        averageUIColor = UIColor(pickedColor)
                                    }
                                    .background(.white)
                            }
                    }
                    
                    Section("Verbal Reminiscence") {
                        Text("Tell us about \"\(text)\"!")
                        RecorderView(id: id)
                            .frame(maxHeight: 400)
                    }
                    
                    Section("Date reminiscence") {
                        DatePicker("When did \n\"\(text)\" \nhappened?", selection: $date, displayedComponents: [.date])
                    }
                }
            }
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        addNewMemory()
                        dismiss()
                    }
                    .disabled(image == nil || averageUIColor == nil || text == "")
                }
            }
        }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
        setAverageColor()
        
    }
    
    func setAverageColor() {
        if let averageColor = inputImage?.averageColor {
            averageUIColor = averageColor
        }
    }
    
    func addNewMemory() {
        let newMemory = Memory(context: viewContext)
        newMemory.name = text
        newMemory.id = id
        newMemory.image = (inputImage?.jpegData(compressionQuality: 1.0)!)!
        newMemory.color = averageUIColor!
        newMemory.date = date
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        scheduleNotification()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription)")
        }
        
        
    }
    
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Do you remember \(text)?"
        content.subtitle = "Go and reminiscence \(text)!"
        content.sound = UNNotificationSound.default
        notificationManager.currentViewId = id
        
        print("added", id)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}










struct AddMemoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoryView()
    }
}
