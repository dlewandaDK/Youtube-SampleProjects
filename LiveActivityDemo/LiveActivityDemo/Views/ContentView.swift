import ActivityKit
import LiveActivityContent
import SwiftUI

@Observable class ViewModel {
    typealias InningInfo = ScoreActivityAttributes.InningInfo
    typealias GameState = ScoreActivityAttributes.GameState
    typealias ContentState = ScoreActivityAttributes.ContentState

    let maxInnings = 9 // TODO: Make dynamic to support shorter games?

    var awayTeamScore = 0
    var homeTeamScore = 0
    var gameState: GameState = .notYetStarted
    func advanceGame() {
        guard gameState != .finished else {
            return
        }

        switch gameState {
            case .notYetStarted:
                gameState = .inProgress(inningInfo: InningInfo())
            case .inProgress(inningInfo: let inningInfo):
                switch inningInfo.inningState {
                    case .top(let outs):
                        if inningInfo.inning >= maxInnings && awayTeamScore > homeTeamScore {
                            gameState = .finished // game over, away team wins
                        } else {
                            switch outs {
                                case .zero:
                                    gameState = .inProgress(
                                        inningInfo: InningInfo(
                                            inning: inningInfo.inning,
                                            inningState: .top(.one)
                                        )
                                    )
                                case .one:
                                    gameState = .inProgress(
                                        inningInfo: InningInfo(
                                            inning: inningInfo.inning,
                                            inningState: .top(.two)
                                        )
                                    )
                                case .two:
                                    gameState = .inProgress(
                                        inningInfo: InningInfo(
                                            inning: inningInfo.inning,
                                            inningState: .middle
                                        )
                                    )
                            }
                        }
                    case .middle:
                        gameState = .inProgress(
                            inningInfo: InningInfo(
                                inning: inningInfo.inning,
                                inningState: .bottom(.zero)
                            )
                        )
                    case .bottom(let outs):
                        switch outs {
                            case .zero:
                                gameState = .inProgress(
                                    inningInfo: InningInfo(
                                        inning: inningInfo.inning,
                                        inningState: .bottom(.one)
                                    )
                                )
                            case .one:
                                gameState = .inProgress(
                                    inningInfo: InningInfo(
                                        inning: inningInfo.inning,
                                        inningState: .bottom(.two)
                                    )
                                )
                            case .two:
                                gameState = .inProgress(
                                    inningInfo: InningInfo(
                                        inning: inningInfo.inning,
                                        inningState: .end
                                    )
                                )
                        }
                    case .end:
                        if inningInfo.inning >= maxInnings && homeTeamScore > awayTeamScore {
                            gameState = .finished // game over, home team wins
                        } else {
                            gameState =
                                .inProgress(
                                    inningInfo: InningInfo(
                                        inning: inningInfo.inning + 1,
                                        inningState: .top(.zero)
                                    )
                                )
                        }
                }
            case .paused:
                gameState = .paused // TODO: Implement starting and ending delay
            case .finished:
                gameState = .finished // Shouldn't ever get here
        }
    }

    func endGame() {
        gameState = .finished
    }

    func awayTeamScored() {
        awayTeamScore += 1
    }

    func homeTeamScored() {
        homeTeamScore += 1
    }

    var currentState: ScoreActivityAttributes.ContentState {
        ContentState(
            gameState: gameState,
            awayTeamScore: awayTeamScore,
            homeTeamScore: homeTeamScore
        )
    }
}

struct ContentView: View {
    @State private var activity: Activity<ScoreActivityAttributes>?
    @State private var allActivities: [Activity<ScoreActivityAttributes>] = []

    @State private var demoContent = DemoContent()
    @State private var viewModel = ViewModel()
    @State private var useBroadcast = false
    @State private var channelName: String = ""

    var body: some View {
        VStack {
            Toggle(useBroadcast ? "Use Broadcast" : "Use Token", isOn: $useBroadcast)
            if useBroadcast {
                TextField("Channel Name", text: $channelName)
            }
            VStack {
                Text("Activity Operations").font(.headline)

                if let activity {
                    Text("Current Activity: \(activity.id)")
                }

                Form {
                    Button("Before", action: startActivity)
                    Button("Game start", action: {
                        updateActivity(newState: viewModel.currentState)
                    })

                    Group {
                        Button(
                            "Advance Inning",
                            action: {
                                viewModel
                                    .advanceGame()
                                updateActivity(
                                    newState: viewModel.currentState
                                )
                            }
                        )

                        HStack {
                            Button(
                                "Away Team Scored",
                                action: {
                                    viewModel
                                        .awayTeamScored()
                                    updateActivity(
                                        newState: viewModel.currentState
                                    )
                                }
                            )
                            Spacer()
                            Button(
                                "Home Team Scored",
                                action: {
                                    viewModel
                                        .homeTeamScored()
                                    updateActivity(
                                        newState: viewModel.currentState
                                    )
                                }
                            )
                        }
                    }
                    .disabled(activity == nil)

                    Button("End", action: finishActivity)
                        .disabled(activity == nil)
                }
                .buttonStyle(.borderedProminent)
            }

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Activity List").font(.headline)

                    Spacer()

                    Button("Refresh", action: refreshActivities)
                }

                if allActivities.isEmpty {
                    Text("No activities running at the moment")
                } else {
                    ForEach(allActivities) { activity in
                        Text(activity.id)
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(perform: refreshActivities)
        .padding()
        .navigationTitle("Live Activity Demo")
        .task { await requestPushPermissions() }
    }

    func refreshActivities() {
        allActivities = Activity<ScoreActivityAttributes>.activities
        activity = allActivities.first
    }

    func requestPushPermissions() async {
        do {
            let _ = try await UNUserNotificationCenter
                .current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            print("got authorization")
        } catch {
            print("error requesting authorization: \(error)")
        }
    }

    static func listenForTokenToStartActivityViaPush() {
        Task {
            for await pushToken in Activity<ScoreActivityAttributes>.pushToStartTokenUpdates {
                let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                print("=== [START] ScoreActivityAttributes: \(pushTokenString)")
            }
        }
    }

    static func listenForTokenToUpdateActivityViaPush() {
        Task {
            for await activityData in Activity<ScoreActivityAttributes>.activityUpdates {
                for await tokenData in activityData.pushTokenUpdates {
                    let token = tokenData.map { String(format: "%02x", $0) }.joined()
                    print("=== [UPDATE] ScoreActivityAttributes [\(activityData.id)] : \(token)")
                }

                for await stateUpdate in activityData.activityStateUpdates {
                    print("=== [STATE] ScoreActivityAttributes [\(activityData.id)] : \(stateUpdate)")
                }

                for await newContent in activityData.contentUpdates {
                    print("=== [CONTENT] ScoreActivityAttributes [\(activityData.id)] : \(newContent)")
                }
            }
        }
    }

    func startActivity() {
        let attrs = ScoreActivityAttributes.previewValue()

        let initialState = ScoreActivityAttributes.ContentState.previewValue(
            gameState: .notYetStarted,
            awayTeamScore: 0,
            homeTeamScore: 0
        )
        let content = ActivityContent(state: initialState, staleDate: nil)

        do {
            activity = try Activity.request(
                attributes: attrs,
                content: content,
                pushType: useBroadcast ? .channel(channelName) : .token
            )

        } catch {
            print(error.localizedDescription)
        }
    }

    func updateActivity(newState: ScoreActivityAttributes.ContentState) {
        guard let activity else { return }

        Task { @MainActor in
            let content = ActivityContent(state: newState, staleDate: nil)
            await activity.update(
                content,
                alertConfiguration: .init(
                    title: "New content!",
                    body: "The game is getting interesting",
                    sound: .default
                )
            )
        }
    }

    func finishActivity() {
        guard let activity else { return }

        Task {
            viewModel.endGame()
            let finalContent = viewModel.currentState
            let dismissalPolicy: ActivityUIDismissalPolicy = .default

            await activity.end(
                ActivityContent(state: finalContent, staleDate: nil),
                dismissalPolicy: dismissalPolicy
            )

            self.activity = nil
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
