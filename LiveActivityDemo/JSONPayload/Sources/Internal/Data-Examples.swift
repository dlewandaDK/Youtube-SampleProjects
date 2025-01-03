import Foundation
import LiveActivityContent

extension JSONEncoder {
    static func pushDecoder(debug: Bool) -> JSONEncoder {
        let decoder = JSONEncoder()
        if debug {
            decoder.dateEncodingStrategy = .iso8601
        } else {
            // This is important to ensure
            // LiveActivities work well with the dates
            // passed to the console
            decoder.dateEncodingStrategy = .secondsSince1970
        }
        return decoder
    }
}

fileprivate func decode<T>(
    _ push: PushPayload<T>,
    _ debug: Bool
) throws -> String {
    let data = try JSONEncoder.pushDecoder(debug: debug).encode(push)
    return try data.prettyPrintedJSONString
}

func beforeGame(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: StartApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .notYetStarted,
                awayTeamScore: 0,
                homeTeamScore: 0
            ),
            attributesType: "ScoreActivityAttributes",
            attributes: ScoreActivityAttributes(
                awayTeam: .init(
                    name: "Away",
                    imageName: "DKSLHD_Black"
                ),
                homeTeam: .init(
                    name: "Home",
                    imageName: "DKSLHD_White"
                ),
                gameStartTime: Date()
            )
        )
    )

    return try decode(push, debug)
}

func gameStart(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init()
                ),
                awayTeamScore: 0,
                homeTeamScore: 0
            )
        )
    )

    return try decode(push, debug)
}

func firstOut(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 1, inningState: .top(.one))
                ),
                awayTeamScore: 0,
                homeTeamScore: 0
            )
        )
    )

    return try decode(push, debug)
}

func firstRun(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 1, inningState: .top(.one))
                ),
                awayTeamScore: 1,
                homeTeamScore: 0
            )
        )
    )

    return try decode(push, debug)
}

func bottomThird(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 3, inningState: .bottom(.two))
                ),
                awayTeamScore: 1,
                homeTeamScore: 0
            )
        )
    )

    return try decode(push, debug)
}

func homeRuns(debug: Bool) throws -> String  {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 3, inningState: .bottom(.two))
                ),
                awayTeamScore: 1,
                homeTeamScore: 3
            )
        )
    )

    return try decode(push, debug)
}

func seventhInningStretch(debug: Bool) throws -> String  {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 7, inningState: .middle)
                ),
                awayTeamScore: 1,
                homeTeamScore: 3
            )
        )
    )

    return try decode(push, debug)
}

func endEighth(debug: Bool) throws -> String  {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .inProgress(
                    inningInfo: .init(inning: 8, inningState: .end)
                ),
                awayTeamScore: 3,
                homeTeamScore: 3
            )
        )
    )

    return try decode(push, debug)
}

func final(debug: Bool) throws -> String  {
    let push = PushPayload(
        aps: EndApsContent(
            contentState: ScoreActivityAttributes.ContentState(
                gameState: .finished,
                awayTeamScore: 3,
                homeTeamScore: 4
            )
        )
    )

    return try decode(push, debug)
}
