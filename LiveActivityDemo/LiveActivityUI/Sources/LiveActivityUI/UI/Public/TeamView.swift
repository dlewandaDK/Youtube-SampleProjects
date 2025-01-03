import SwiftUI

public struct TeamView: View {
    let name: String
    let imageName: String

    @Environment(\.activityFamily) private var activityFamily

    public init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }

    var imageSize: CGFloat { activityFamily == .small ? 40 : 66 }

    public var body: some View {
        VStack(spacing: 4) {
            if activityFamily != .small {
                Image(uiImage: UIImage(named: imageName) ?? UIImage(systemName: "baseball")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
            }

            Text(name)
                .font(.caption.bold())
        }
    }
}


#Preview("Medium") {
    TeamView(name: "Diamonds", imageName: "DKSLHD_Black")
        .environment(\.activityFamily, .medium)
}

#Preview("Small") {
    TeamView(name: "Diamonds", imageName: "DKSLHD_Black")
        .environment(\.activityFamily, .small)
}
