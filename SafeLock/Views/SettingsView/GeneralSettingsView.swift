// MARK: Imports
import SwiftUI

// MARK: - General Settings View
/// The general settings SwiftUI view for the settings screen of the application
struct GeneralSettingsView: View {
  @AppStorage("\(Bundle.main.bundleIdentifier!).saveState") var saveState: Bool = false // Save state setting

  var body: some View {
    VStack {
      Toggle("Save recording on exit", isOn: $saveState) // Toggle to enable/disable saving the recording on exit
    }
  }
}
