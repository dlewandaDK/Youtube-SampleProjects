import SwiftUI

struct GameStartTimeView: View {
    let startTime: Date

    var body: some View {
        VStack {
            Text("Starts")
            Text(startTime.formatted(date: .omitted, time: .shortened))
        }
        .bold()
    }
}
