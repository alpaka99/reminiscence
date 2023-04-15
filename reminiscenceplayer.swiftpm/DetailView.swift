//
//  DetailView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI

struct DetailView: View {
    let memory: Memory
    
    var body: some View {
        VStack {
            Text(memory.name)
            Image(uiImage: UIImage(data: memory.image)!)
        }
        .background(Color(memory.color))
        .onAppear {
            print(memory)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(memory: Memory)
//    }
//}
