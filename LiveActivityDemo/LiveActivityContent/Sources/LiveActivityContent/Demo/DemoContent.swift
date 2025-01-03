import Foundation

public struct DemoContent {
    public typealias Content = ScoreActivityAttributes.ContentState

    public init() {}

    public func notYetStarted() -> Content {
        .init(gameState: .notYetStarted, awayTeamScore: 0, homeTeamScore: 0)
    }

    public func gameStart() -> Content {
        .init(
            gameState: .inProgress(
                inningInfo: .init()
            ),
            awayTeamScore: 0,
            homeTeamScore: 0
        )
    }

    public func gameOver() -> Content {
        .init(
            gameState: .finished,
            awayTeamScore: 2,
            homeTeamScore: 1
        )
    }
}
