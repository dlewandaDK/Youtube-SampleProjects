import SwiftUI

public struct ScoreView: View {
    let away: Int
    let home: Int

    @Environment(\.activityFamily) private var activityFamily

    public init(
        away: Int,
        home: Int
    ) {
        self.away = away
        self.home = home
    }

    var spacing: CGFloat { activityFamily == .small ? 14 : 21 }
    var scoreSize: CGFloat { activityFamily == .small ? 27 : 44 }
    var separatorSize: CGFloat { activityFamily == .small ? 27 : 38 }

    public var body: some View {
        HStack {
            Text(away.formatted())
                .font(.system(size: scoreSize, weight: .bold).monospacedDigit())

            Text(home.formatted())
                .font(.system(size: scoreSize, weight: .bold).monospacedDigit())
        }
    }

    public struct MinimalView: View {
        let away: Int
        let home: Int

        public init(away: Int, home: Int) {
            self.away = away
            self.home = home
        }

        public var body: some View {
            Text("\(away.formatted()) : \(home.formatted())")
                .monospacedDigit()
        }
    }
}

#Preview {
    ScoreView(away: 0, home: 0)
}

#Preview("Minimal") {
    ScoreView.MinimalView(away: 0, home: 0)
}
