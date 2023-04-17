//
//  EditView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/18.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
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
                if let loadedImage = image {
                    Section {
                        loadedImage
                            .resizable()
                            .scaledToFit()
                        
                        
                        
                        Button("Change image") {
                            showImagePicker = true
                            
                        }
                        
                        // dominat color & color picker
                        Rectangle()
                            .fill((averageUIColor != nil) ? Color(averageUIColor!) : .clear)
                        
                        
                        
                        ColorPicker("Pick this memory's color", selection: $pickedColor)
                            .onChange(of: pickedColor) { _ in
                                averageUIColor = UIColor(pickedColor)
                            }
                    }
                    
                    Section {
                        TextField("What is the title of this memory?", text: $text)
                            .frame(maxWidth: .infinity)
                        
                        
                        RecorderView(id: id)
                            
                    }
                    
                    Section {
                        DatePicker("When did this memory happened?", selection: $date, displayedComponents: [.date])
                    }
                    
                    
                } else {
                    ZStack {
                        Rectangle()
                            .fill(.secondary)

                        Text("Tap to select a picture")
                    }
                    .onTapGesture {
                        showImagePicker = true
                    }
                }
            }
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
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
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
        setAverageColor()
        
    }
    
    func setAverageColor() {
        if let averageColor = inputImage?.averageColor {
//            let hexValue = averageColor.toHexString()
//            averageUIColor = hexValue
            averageUIColor = averageColor
        }
    }
    
    func addNewMemory() {
//        let jpeg = inputImage?.jpegData(compressionQuality: 1.0)
        
        let newMemory = Memory(context: viewContext)
        newMemory.name = text
        newMemory.id = id
        newMemory.image = (inputImage?.jpegData(compressionQuality: 1.0)!)!
        newMemory.color = averageUIColor!
        newMemory.date = date
        
        
        do {
            try viewContext.save()
            print(memories.count)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription)")
        }
        
        print(memories.count)
    }

}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
