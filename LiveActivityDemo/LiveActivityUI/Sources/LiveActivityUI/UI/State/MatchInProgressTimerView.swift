import LiveActivityContent
import SwiftUI
import WidgetKit

struct MatchInProgressTimerView: View {
    let inningInfo: ScoreActivityAttributes.InningInfo

    private let pillColor: Color = .init(red: 73 / 255, green: 148 / 255, blue: 57 / 255)

    var body: some View {
        VStack(spacing: 0) {
            Text(inningInfo.displayString)
        }
        .multilineTextAlignment(.center)
    }
}
