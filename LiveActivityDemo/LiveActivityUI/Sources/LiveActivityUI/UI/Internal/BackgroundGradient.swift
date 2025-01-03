import LiveActivityContent
import SwiftUI

struct BackgroundGradient: View {
    var matchState: ScoreActivityAttributes.GameState

    var body: some View {
        switch matchState {
            case .notYetStarted, .finished:
                LinearGradient(
                    colors: [.gray, .gray.opacity(0.75)],
                    startPoint: .topTrailing,
                    endPoint: .bottom
                )

            default:
                LinearGradient(
                    colors: [.green, .green.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottom
                )
        }
    }
}

#Preview("Not Started") {
    BackgroundGradient(matchState: .notYetStarted)
}

#Preview("In Progress") {
    BackgroundGradient(matchState: .inProgress(inningInfo: .init()))
}

#Preview("Paused") {
    BackgroundGradient(matchState: .paused)
}

#Preview("Ended") {
    BackgroundGradient(matchState: .finished)
}


