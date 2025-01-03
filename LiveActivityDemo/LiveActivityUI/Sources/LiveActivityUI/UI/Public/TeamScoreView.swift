import SwiftUI

public struct TeamScoreView: View {
    let imageName: String
    let score: Int
    let isLeading: Bool

    public init(imageName: String, score: Int, isLeading: Bool) {
        self.imageName = imageName
        self.score = score
        self.isLeading = isLeading
    }

    public var body: some View {
        HStack(spacing: 4) {
            if isLeading {
                image

                text
            } else {
                text

                image
            }
        }
    }

    var image: some View {
        Image(uiImage: UIImage(named: imageName) ?? UIImage(systemName: "baseball")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 28, height: 28)
    }

    var text: some View {
        Text(score.formatted())
            .monospacedDigit()
    }
}

#Preview{
    TeamScoreView(imageName: "DKSLHD_Black", score: 1, isLeading: true)
}
