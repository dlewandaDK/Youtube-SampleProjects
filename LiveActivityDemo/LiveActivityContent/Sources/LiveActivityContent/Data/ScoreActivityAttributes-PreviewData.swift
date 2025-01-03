import Foundation

public extension ScoreActivityAttributes {
    static func previewValue(
        awayTeam: Team = .previewValue(
            name: "Away",
            imageName: "DKSLHD_Black"
        ),
        homeTeam: Team = .previewValue(
            name: "Home",
            imageName: "DKSLHD_White"
        ),
        gameStartTime: Date = Date()
    ) -> Self {
        .init(
            awayTeam: awayTeam,
            homeTeam: homeTeam,
            gameStartTime: gameStartTime
        )
    }
}

public extension ScoreActivityAttributes.Team {
    static func previewValue(
        name: String = "DK",
        imageName: String = "DKSLHD_Black"
    ) -> Self {
        .init(
            name: name,
            imageName: imageName
        )
    }
}

public extension ScoreActivityAttributes.InningInfo {
    static func previewValue(
        name: String = "top first"
    ) -> Self {
        .init(inning: 1, inningState: .top(.one))
    }
}

public extension ScoreActivityAttributes.ContentState {
    static func previewValue(
        gameState: ScoreActivityAttributes.GameState = .inProgress(inningInfo: .init(inning: 7, inningState: .top(.one))),
        awayTeamScore: Int = 2,
        homeTeamScore: Int = 1
    ) -> Self {
        .init(gameState: gameState, awayTeamScore: awayTeamScore, homeTeamScore: homeTeamScore)
    }
}
