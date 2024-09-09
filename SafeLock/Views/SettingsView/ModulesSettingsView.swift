// MARK: Imports
import SwiftUI

// MARK: - Modules Settings View
/// The modules settings SwiftUI view for the settings screen of the application
struct ModulesSettingsView: View {
@AppStorage("\(Bundle.main.bundleIdentifier!).mouseModuleState") var mouseModuleState: Bool = true // Mouse module setting
  var body: some View {
    VStack {
      Toggle("Mouse monitor", isOn: $mouseModuleState) // Toggle to enable/disable mouse monitor
    }
  }
}
