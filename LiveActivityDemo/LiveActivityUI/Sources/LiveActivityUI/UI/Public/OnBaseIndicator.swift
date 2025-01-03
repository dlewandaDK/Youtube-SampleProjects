//
//  BaseballOnBaseIndicator.swift
//  LiveActivityUI
//
//  Created by Dave Lewanda on 12/24/24.
//


import SwiftUI

struct OnBaseIndicator: View {
    // State to indicate which bases are occupied
    @Binding private var bases: [Bool] // [1B, 2B, 3B, Home]

    init(bases: Binding<[Bool]>) {
        self._bases = bases
    }

    var body: some View {
        ZStack {
            // Base indicators
            Group {
                Base(isOccupied: bases[1]) // 2B
                    .offset(x: 0, y: -75)

                Base(isOccupied: bases[2]) // 3B
                    .offset(x: -75, y: 0)

                Base(isOccupied: bases[0]) // 1B
                    .offset(x: 75, y: 0)

            }
        }
    }
}

// Custom diamond shape
struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: CGPoint(x: center.x, y: center.y - radius)) // Top
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y)) // Right
        path.addLine(to: CGPoint(x: center.x, y: center.y + radius)) // Bottom
        path.addLine(to: CGPoint(x: center.x - radius, y: center.y)) // Left
        path.closeSubpath()

        return path
    }
}

// Custom base indicator circle
struct Base: View {
    var isOccupied: Bool

    var body: some View {
        DiamondShape()
            .fill(isOccupied ? Color.gray : Color.white)
            .overlay(
                DiamondShape()
                    .stroke(Color.black, lineWidth: 2)
            )
            .frame(width: 100, height: 100)
    }
}

// Preview

struct BaseIndicatorPreviewView: View {

    @State var bases: [Bool] = [false, false, false]

    var body: some View {
        VStack {
            OnBaseIndicator(bases: $bases)
            // Toggle buttons for testing
            HStack {
                ForEach(0..<3) { index in
                    Button(action: {
                        bases[index].toggle()
                    }) {
                        Text(baseLabel(for: index))
                            .padding()
                            .background(bases[index] ? Color.blue : Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }

    }

    // Helper function for base labels
    func baseLabel(for index: Int) -> String {
        switch index {
            case 0: return "1B"
            case 1: return "2B"
            case 2: return "3B"
            case 3: return "Home"
            default: return ""
        }
    }
}

#Preview {
    BaseIndicatorPreviewView()
}
