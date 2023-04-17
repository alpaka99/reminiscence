//
//  BarView.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/16.
//

import SwiftUI

struct BarView: View {
    let numberOfSamples: Int = 10

   // 1
    var value: CGFloat

    var body: some View {
            ZStack {
                // 2
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                // 3
                //                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value / 5)
                                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 10) / CGFloat(numberOfSamples), height: value / 5)
            }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 1000)
    }
}
