//
//  OutsIndicator.swift
//  LiveActivityUI
//
//  Created by Dave Lewanda on 12/24/24.
//


import SwiftUI

struct OutsIndicator: View {
    var outs: Int // 0, 1, or 2

    var body: some View {
            HStack {
                ForEach(0..<2, id: \.self) { index in
                    Circle()
                        .fill(index < outs ? Color.white : Color.gray.opacity(0.9))
                }
            }
    }
}

// Preview
struct OutsIndicatorPreviewView: View {
    @State private var outs: Int = 0 // Number of outs (0, 1, or 2)

    var body: some View {
        VStack {
            Text("Outs")
                .font(.headline)
                .padding(.bottom, 8)

            OutsIndicator(outs: outs)

            Button("Out") {
                outs = (outs + 1) % 3
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(.yellow)
    }
}

#Preview {
    OutsIndicatorPreviewView()
}
