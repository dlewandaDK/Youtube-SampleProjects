import Foundation
import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
    import ActivityKit

    extension ScoreActivityAttributes: ActivityAttributes {}
#endif

public struct ScoreActivityAttributes: Codable {
    public let awayTeam: Team
    public let homeTeam: Team
    public let gameStartTime: Date

    public init(awayTeam: Team, homeTeam: Team, gameStartTime: Date) {
        self.awayTeam = awayTeam
        self.homeTeam = homeTeam
        self.gameStartTime = gameStartTime
    }

    public struct ContentState: Codable, Hashable {
        public let gameState: GameState
        public let awayTeamScore: Int
        public let homeTeamScore: Int

        public init(gameState: GameState, awayTeamScore: Int, homeTeamScore: Int) {
            self.gameState = gameState
            self.awayTeamScore = awayTeamScore
            self.homeTeamScore = homeTeamScore
        }
    }

    public enum GameState: Codable, Hashable {
        case notYetStarted
        case inProgress(inningInfo: InningInfo)
        case paused
        case finished
    }

    public struct InningInfo: Codable, Hashable {
        public let inning: Int
        public let inningState: InningState

        public init(inning: Int = 1, inningState: InningState = .top(.zero)) {
            self.inning = inning
            self.inningState = inningState
        }

        public var displayString: String {
            "\(inningState.displayString) \(inning)"
        }
    }

    public enum InningState: Codable, Hashable {
        case top(Outs), middle, bottom(Outs), end

        var displayString: String {
            switch self {
                case .top:
                    "Top"
                case .middle:
                    "Mid"
                case .bottom:
                    "Bot"
                case .end:
                    "End"
            }
        }
    }

    public enum Outs: Codable, Hashable {
        case zero, one, two

        public var intValue: Int {
            switch self {
                case .zero:
                    0
                case .one:
                    1
                case .two:
                    2
            }
        }
    }

    public struct Team: Codable, Hashable {
        public let name: String

        // WARNING: for this example, I'm using an `imageName` that will
        // be the name of an asset in the AssetCatalog of the LiveActivities target
        // for simplicity. Another approach would be needed for a production app
        public let imageName: String

        public init(name: String, imageName: String) {
            self.name = name
            self.imageName = imageName
        }
    }
}
