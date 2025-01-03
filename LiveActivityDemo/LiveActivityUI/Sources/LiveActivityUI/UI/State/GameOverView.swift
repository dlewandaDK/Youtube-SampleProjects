import SwiftUI

struct GameOverView: View {
    private let color: Color = .init(red: 167 / 255, green: 215 / 255, blue: 179 / 255)

    var body: some View {
        Pill(text: "Final", color: color)
    }
}
