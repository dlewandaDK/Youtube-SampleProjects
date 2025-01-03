import LiveActivityContent
import SwiftUI

public struct GameView: View {
    var attrs: ScoreActivityAttributes
    var state: ScoreActivityAttributes.ContentState

    @Environment(\.activityFamily) var activityFamily

    public init(attrs: ScoreActivityAttributes, state: ScoreActivityAttributes.ContentState) {
        self.attrs = attrs
        self.state = state
    }

    public var body: some View {
        Group {
            switch activityFamily {
            case .small:
                small

            case .medium:
                medium

            @unknown default:
                medium
            }
        }.onAppear {
            print("----------------- MYWIDGET ------------------")
            dump(attrs)
            dump(state)
        }
    }

    var small: some View {
        VStack(alignment: .center) {
            HStack {
                TeamView(name: attrs.awayTeam.name, imageName: attrs.awayTeam.imageName)
                Spacer()
                ScoreView(away: state.awayTeamScore, home: state.homeTeamScore)
                Spacer()
                TeamView(name: attrs.homeTeam.name, imageName: attrs.homeTeam.imageName)
            }
            .padding()

            GameStateView.SmallView(attrs: attrs, state: state)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white) // semantic?
        .background(BackgroundGradient(matchState: state.gameState))
    }

    var medium: some View {
        HStack(spacing: 30) {
            TeamView(name: attrs.awayTeam.name, imageName: attrs.awayTeam.imageName)

            GameStateView(attrs: attrs, state: state)

            TeamView(name: attrs.homeTeam.name, imageName: attrs.homeTeam.imageName)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundStyle(.white) // semantic?
        .background(BackgroundGradient(matchState: state.gameState))
    }
}


#Preview("Small") {
    GameView(attrs: .previewValue(), state: .previewValue())
        .environment(\.activityFamily, .small)
}

#Preview("Medium") {
    GameView(attrs: .previewValue(), state: .previewValue())
        .environment(\.activityFamily, .medium)
}
