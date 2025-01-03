import LiveActivityContent
import SwiftUI

public struct GameStateView: View {
    var attrs: ScoreActivityAttributes
    var state: ScoreActivityAttributes.ContentState
    
    var topOffset: CGFloat { state.gameState == .notYetStarted ? 0 : -16 }
    
    public init(attrs: ScoreActivityAttributes, state: ScoreActivityAttributes.ContentState) {
        self.attrs = attrs
        self.state = state
    }
    
    public var body: some View {
        VStack {
            TopView(attrs: attrs, state: state)
                //.offset(y: topOffset)

            BottomView(attrs: attrs, state: state)
                //.frame(maxHeight: .infinity, alignment: .bottom)
                //.offset(y: 8)
        }
    }
    
    public struct TopView: View {
        var attrs: ScoreActivityAttributes
        var state: ScoreActivityAttributes.ContentState
        
        public init(attrs: ScoreActivityAttributes, state: ScoreActivityAttributes.ContentState) {
            self.attrs = attrs
            self.state = state
        }
        
        public var body: some View {
            switch state.gameState {
                case .notYetStarted:
                    GameStartTimeView(startTime: attrs.gameStartTime)
                    
                case .inProgress(let inningInfo):
                    VStack(spacing: .zero) {
                        Spacer()
                        ScoreView(away: state.awayTeamScore, home: state.homeTeamScore)
                        switch inningInfo.inningState {
                            case .top(let outs), .bottom(let outs):
                                OutsIndicator(outs: outs.intValue)
                            default:
                                EmptyView()
                        }
                        Spacer()
                    }
                case .finished, .paused:
                    ScoreView(away: state.awayTeamScore, home: state.homeTeamScore)

            }
        }
    }
    
    public struct BottomView: View {
        var attrs: ScoreActivityAttributes
        var state: ScoreActivityAttributes.ContentState
        
        public init(attrs: ScoreActivityAttributes, state: ScoreActivityAttributes.ContentState) {
            self.attrs = attrs
            self.state = state
        }
        
        public var body: some View {
            switch state.gameState {
                case .notYetStarted:
                    EmptyView()
                    
                case let .inProgress(inningInfo):
                    Text(inningInfo.displayString)

                case .paused:
                    GameDelayedView()
                    
                case .finished:
                    GameOverView()
            }
        }
    }
    
    public struct SmallView: View {
        var attrs: ScoreActivityAttributes
        var state: ScoreActivityAttributes.ContentState
        
        public init(attrs: ScoreActivityAttributes, state: ScoreActivityAttributes.ContentState) {
            self.attrs = attrs
            self.state = state
        }
        
        public var body: some View {
            Group {
                switch state.gameState {
                    case .notYetStarted:
                        Text("Starts \(attrs.gameStartTime.formatted(date: .omitted, time: .shortened))")

                    case let .inProgress(inningInfo):
                        Text(inningInfo.displayString)

                    case .paused:
                        Text("Delayed")
                        
                    case .finished:
                        Text("Final")
                }
            }
            .font(.caption2.monospacedDigit())
            .multilineTextAlignment(.center)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview("Game starting now") {
    GameStateView(
        attrs: ScoreActivityAttributes(
            awayTeam: ScoreActivityAttributes.Team(name: "Away", imageName: "DKSLHD_White"),
            homeTeam: ScoreActivityAttributes.Team(name: "Home", imageName: "DKSLHD_Black"),
            gameStartTime: .now
        ),
        state: ScoreActivityAttributes.ContentState(
            gameState: .notYetStarted,
            awayTeamScore: 0, homeTeamScore: 0
        )
    )
    .background {
        Color.gray.opacity(0.5)
    }
}

#Preview("Top 1, No Outs, 0-1") {
    GameStateView(
        attrs: ScoreActivityAttributes(
            awayTeam: ScoreActivityAttributes.Team(name: "Away", imageName: "DKSLHD_White"),
            homeTeam: ScoreActivityAttributes.Team(name: "Home", imageName: "DKSLHD_Black"),
            gameStartTime: .now
        ),
        state: ScoreActivityAttributes.ContentState(
            gameState: .inProgress(inningInfo: ScoreActivityAttributes.InningInfo(inning: 1, inningState: .top(.zero))),
            awayTeamScore: 0,
            homeTeamScore: 1
        )
    )
    .background {
        Color.gray.opacity(0.5)
    }
}

#Preview("Mid 7, 3-1") {
    GameStateView(
        attrs: ScoreActivityAttributes(
            awayTeam: ScoreActivityAttributes.Team(name: "Away", imageName: "DKSLHD_White"),
            homeTeam: ScoreActivityAttributes.Team(name: "Home", imageName: "DKSLHD_Black"),
            gameStartTime: .now
        ),
        state: ScoreActivityAttributes.ContentState(
            gameState: .inProgress(inningInfo: ScoreActivityAttributes.InningInfo(inning: 1, inningState: .middle)),
            awayTeamScore: 3,
            homeTeamScore: 1
        )
    )
    .background {
        Color.gray.opacity(0.5)
    }
}

#Preview("Game over") {
    GameStateView(
        attrs: ScoreActivityAttributes(
            awayTeam: ScoreActivityAttributes.Team(name: "Away", imageName: "DKSLHD_White"),
            homeTeam: ScoreActivityAttributes.Team(name: "Home", imageName: "DKSLHD_Black"),
            gameStartTime: .now
        ),
        state: ScoreActivityAttributes.ContentState(
            gameState: .finished,
            awayTeamScore: 3,
            homeTeamScore: 4
        )
    )
    .background {
        Color.gray.opacity(0.5)
    }
}
