//
//  AddMemory.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/15.
//

import SwiftUI
//import CoreImage
import CoreData

struct AddMemoryView: View {
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
    @State var name = "memory"
    
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("What's the name of this memory?", text: $text)
                        .onSubmit {
                            name = text
                        }
                }
                
//                if let loadedImage = image {
                Section("Visual reminiscence") {
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
                                
                                Text("Tap if you have picture of \n\"\(name)\"")
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
                                ColorPicker("What color resembles \n\"\(name)\"?", selection: $pickedColor)
                                    .onChange(of: pickedColor) { _ in
                                        averageUIColor = UIColor(pickedColor)
                                    }
                                    .background(.white)
                            }
                        
                        
                        
                        
                    }
                    
                    Section("Verbal reminiscence") {
//                        TextField("What is the title of this memory?", text: $text)
//                            .frame(maxWidth: .infinity)
                        
                        Text("Tell us about \"\(name)\"!")
                        RecorderView(id: id)
                            .frame(maxHeight: 400)
                    }
                    
                    Section("Date reminiscence") {
                        DatePicker("When did \n\"\(name)\" \nhappened?", selection: $date, displayedComponents: [.date])
                    }
                
                    Text("How was weather like on \n\"\(name)\"?")
                    // picker
                    
                    
                }
//                    else {
//                    ZStack {
//                        Rectangle()
//                            .fill(.secondary)
//
//                        Text("Tap to select a picture")
//                    }
//                    .onTapGesture {
//                        showImagePicker = true
//                    }
//                }
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
//    }
    
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


// Getting average(dominant) color of a image
extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor? {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return nil }

        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}

// uicolor to hexvalue extension or vice-versa
extension UIColor {
        func toHexString() -> String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0

            getRed(&r, green: &g, blue: &b, alpha: &a)

            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

            return String(format:"#%06x", rgb)
        }
    
        public convenience init?(hex: String) {
                let r, g, b, a: CGFloat

                if hex.hasPrefix("#") {
                    let start = hex.index(hex.startIndex, offsetBy: 1)
                    let hexColor = String(hex[start...])

                    if hexColor.count == 8 {
                        let scanner = Scanner(string: hexColor)
                        var hexNumber: UInt64 = 0

                        if scanner.scanHexInt64(&hexNumber) {
                            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                            a = CGFloat(hexNumber & 0x000000ff) / 255

                            self.init(red: r, green: g, blue: b, alpha: a)
                            return
                        }
                    }
                }

                return nil
            }
    }

struct AddMemoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoryView()
    }
}
