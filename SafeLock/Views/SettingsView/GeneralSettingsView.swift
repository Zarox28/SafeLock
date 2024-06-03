// MARK: Imports
import SwiftUI

// MARK: - General Settings View
/// The general settings SwiftUI view for the settings screen of the application
struct GeneralSettingsView: View {
  var body: some View {
    VStack {}
    .padding().ignoresSafeArea()
    .frame(width: 300, height: 200)
    .background(BlurBackground().ignoresSafeArea()) // Apply blurred background
  }
}
