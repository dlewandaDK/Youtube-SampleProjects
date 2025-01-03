import ActivityKit
import Foundation
import LiveActivityContent
import LiveActivityUI
import SwiftUI
import WidgetKit

struct GameScoreLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScoreActivityAttributes.self) { context in
            GameView(attrs: context.attributes, state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TeamView(
                        name: context.attributes.awayTeam.name,
                        imageName: context.attributes.awayTeam.imageName
                    )
                    .padding(.leading)
                }

                DynamicIslandExpandedRegion(.center) {
                    GameStateView.TopView(attrs: context.attributes, state: context.state)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    TeamView(
                        name: context.attributes.homeTeam.name,
                        imageName: context.attributes.homeTeam.imageName
                    )
                    .padding(.trailing)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    GameStateView.BottomView(attrs: context.attributes, state: context.state)
                }

            } compactLeading: {
                TeamScoreView(
                    imageName: context.attributes.awayTeam.imageName,
                    score: context.state.awayTeamScore,
                    isLeading: true
                )

            } compactTrailing: {
                TeamScoreView(
                    imageName: context.attributes.homeTeam.imageName,
                    score: context.state.homeTeamScore,
                    isLeading: false
                )

            } minimal: {
                ScoreView.MinimalView(
                    away: context.state.awayTeamScore,
                    home: context.state.homeTeamScore
                )
            }
        }
        .supplementalActivityFamilies([.small])
    }
}

#Preview(
    "Dynamic Island Compact",
    as: .content,
    using: ScoreActivityAttributes.previewValue()
) {
    GameScoreLiveActivity()
} contentStates: {
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .notYetStarted,
        awayTeamScore: 0,
        homeTeamScore: 0
    )
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .inProgress(inningInfo: .init(inning: 1, inningState: .bottom(.two))),
        awayTeamScore: 0,
        homeTeamScore: 1
    )
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .inProgress(inningInfo: .init(inning: 3, inningState: .middle)),
        awayTeamScore: 1,
        homeTeamScore: 1
    )
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .paused,
        awayTeamScore: 2,
        homeTeamScore: 1
    )
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .inProgress(inningInfo: .init(inning: 8, inningState: .bottom(.two))),
        awayTeamScore: 2,
        homeTeamScore: 1
    )
    ScoreActivityAttributes.ContentState.previewValue(
        gameState: .finished,
        awayTeamScore: 2,
        homeTeamScore: 1
    )
}
