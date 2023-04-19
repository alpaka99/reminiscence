//
//  ColorChip.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/19.
//

import Foundation
import SwiftUI

struct Colorchip: View {
    let image: Data
    let name: String
    let date: Date
    let color: Color
    let scale: CGFloat
    var dateFormatted: String {
        return "\(date.get(.year))/\(date.get(.month))/\(date.get(.day))"
    }
    
    var body: some View {
        let width: CGFloat = 57*scale
        let height: CGFloat = 90*scale
        
        VStack(alignment: .leading) {
            Image(uiImage: (UIImage(data: image) ?? UIImage(named: "sample_image")!))
                .resizable()
                .scaledToFit()
//            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text(name)
                            .font(Font.custom("HelveticaNeue-Bold", size: 7.5*scale))
                        Text("®")
                            .font(Font.custom("HelveticaNeue-Bold", size: 3*scale))
                    }
                    Text(dateFormatted)
                        .font(Font.custom("HelveticaNeue-Bold", size: 6.5*scale))
                }
                Spacer()
            }
            .padding(.horizontal, 5)
            .frame(width: width - 3 * scale, height: height / 3.5)
            .background(RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white))
            
        }
        .padding(3)
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: 5).fill(color))
    }
}
