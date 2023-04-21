//
//  SwiftUIView.swift
//  
//
//  Created by user on 2023/04/19.
//

import SwiftUI

struct BackgroundView: View {
    @State var scale : CGFloat = 1
    let rouge = Color(red: 0.01, green: 0.05, blue: 0.2)
    var body: some View {
        
        ZStack {
            ForEach (1...20, id:\.self) { _ in
                Circle ()
                    .foregroundColor(Color (red: 0.01,
                                            green: 0.05,
                                            blue: .random(in: 0.05...0.3)))
                    .opacity(scale)
                
                    .blendMode(.colorDodge)
                    .animation (Animation.spring (dampingFraction: 0.5)
                        .repeatForever()
                        .speed (.random(in: 0.05...0.2))
                        .delay(.random (in: 0...0.5)), value: scale
                    )
                    .scaleEffect(self.scale * .random(in: 0.1...3))
                    .frame(width: .random(in: 1...100),
                           height: CGFloat.random (in:20...100),
                           alignment: .center)
                    .position(CGPoint(x: .random(in: 0...1112),
                                      y: .random (in:0...834)))
            }
        }
        .onAppear {
            self.scale = 1.2 // default circle scale
        }
        
        .drawingGroup(opaque: false, colorMode: .linear)
        .background(
            LinearGradient(colors: [.blue, .white],
                                           startPoint: .top,
                                           endPoint: .bottom)
                .foregroundColor(Color(red: 80/255, green: 120/255, blue: 230/255)))
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
