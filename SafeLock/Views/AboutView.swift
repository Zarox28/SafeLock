// MARK: Import
import SwiftUI

// MARK: - About View
/// The SwiftUI view for the about screen
struct AboutView: View {
  var body: some View {
    VStack {
      VStack(spacing: 35) {
        // MARK: Logo & Name
        HStack(spacing: 20) {
          // Logo
          Image("AboutIcon")
            .resizable()
            .frame(width: 90, height: 90)

          // Name
          VStack(spacing: 5) {
            Text("SafeLock")
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
              .bold()

            Text("By Zarox28")
          }
        }
        .frame(maxWidth: .infinity)

        // MARK: Informations & GitHub Button
        HStack(alignment: .bottom) {
          // App informations
          VStack(alignment: .leading) {
            // Release
            HStack {
              Text("Release:")
                .bold()

              Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
            }

            // Build
            HStack {
              Text("Build:")
                .bold()

              Text(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
            }
          }

          Spacer()

          // GitHub button
          Link(destination: URL(string: "https://github.com/Zarox28/SafeLock")!) {
            Image("GitHubLogo")
              .resizable()
              .frame(width: 20, height: 20)

            Image("GitHubText")
              .resizable()
              .frame(width: 50, height: 20)
          }
          .buttonStyle(.bordered)
          .controlSize(.large)
        }
        .frame(maxWidth: .infinity)
      }
      .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
    }
    .padding().ignoresSafeArea()
    .frame(width: 300, height: 200)
    .background(BlurBackground().ignoresSafeArea()) // Apply blurred background
  }
}
