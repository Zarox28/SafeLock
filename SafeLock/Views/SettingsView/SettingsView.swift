// MARK: Imports
import SwiftUI

// MARK: - Settings View
/// The settings SwiftUI view for the settings screen of the application
struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, modules
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            ModulesSettingsView()
                .tabItem {
                    Label("Modules", systemImage: "checklist")
                }
                .tag(Tabs.modules)
        }
        .padding().ignoresSafeArea()
        .frame(width: 300, height: 200)
        .background(BlurBackground().ignoresSafeArea()) // Apply blurred background
    }
}
