// MARK: Imports
import SwiftUI

// MARK: - Application Delegate
/// This class implements NSApplicationDelegate to remove default menubar items and handle application termination
class AppDelegate: NSObject, NSApplicationDelegate {
  // MARK: Remove Default Menubar Items
  /// This method is called before the application updates
  func applicationWillUpdate(_ notification: Notification) {
    if let menu = NSApplication.shared.mainMenu {
      if let file = menu.items.first(where: { $0.title == "File"}) { menu.removeItem(file) }
      if let edit = menu.items.first(where: { $0.title == "Edit"}) { menu.removeItem(edit) }
      if let window = menu.items.first(where: { $0.title == "Window"}) { menu.removeItem(window) }
      if let view = menu.items.first(where: { $0.title == "View"}) { menu.removeItem(view) }
      if let help = menu.items.first(where: { $0.title == "Help"}) { menu.removeItem(help) }
    }
  }

  // MARK: Application Termination
  /// This method is called when the application is about to terminate
  func applicationWillTerminate(_ aNotification: Notification) {
    // Remove temporary video file if it exists
    if CameraManager.shared.hasRecorded { // Check if a video has been recorded
      if UserDefaults.standard.bool(forKey: "\(Bundle.main.bundleIdentifier!).saveState") { // Check if the user has enabled saving the video
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yy-HH_mm"

        // Move the video file to the desktop
        let fileManager = FileManager.default
        let desktopURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let newFileName = "\(dateFormatter.string(from: Date())).\(URL(fileURLWithPath: CameraManager.shared.recordPath).pathExtension)"
        let destinationURL = desktopURL.appendingPathComponent(newFileName)

        try? fileManager.moveItem(at: URL(fileURLWithPath: CameraManager.shared.recordPath), to: destinationURL)

        CameraManager.shared.removeRecord() // Remove the temporary video file
      } else {
        CameraManager.shared.removeRecord() // Remove the temporary video file
      }
    }
  }
}

// MARK: - Blur Background
/// A struct representing a SwiftUI view that creates a blurred background using NSVisualEffectView
struct BlurBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    let effectView = NSVisualEffectView()

    effectView.state = .active // Set to active for the blurred effect

    return effectView
  }

  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

// MARK: - SafeLock App
/// The main entry point of the application, conforming to the App protocol
@main
struct SecureMacApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate // Manages the main application window in MacOS context
  @Environment(\.openWindow) var openWindow // Function to open a new window
  @State private var window: NSWindow! // Manages the main application window

  var body : some Scene {
    // MARK: Main Window
    /// Display the main window
    WindowGroup("SafeLock", id: "main") {
      MainView()
        .background { // Hide zoom & miniaturize buttons
          if window == nil {
            Color.clear.onReceive(NotificationCenter.default.publisher(
              for:
                NSWindow.didBecomeKeyNotification)) { notification in
                  if let window = notification.object as? NSWindow {
                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                  }
                }
          }
        }
    }
    .windowStyle(HiddenTitleBarWindowStyle()) // Set the window style to hidden title bar
    .windowToolbarStyle(UnifiedCompactWindowToolbarStyle()) // Set the window toolbar style
    .windowResizability(.contentSize) // Set window resizability to content size
    .defaultPosition(.center) // Display window in center of screen
    .commands {
      CommandGroup(replacing: CommandGroupPlacement.systemServices) {} // Hide services menu item
      CommandGroup(replacing: CommandGroupPlacement.appVisibility) {} // Hide app visibility menu item
      CommandGroup(replacing: CommandGroupPlacement.appInfo) { // Replace default app information menu
        Button("About SafeLock") {
          openWindow(id: "about")
        }
        .keyboardShortcut("i", modifiers: .command) // Set keyboard shortcut
      }
    }

    // MARK: Settings Window
    /// Display the settings window if the platform is macOS
#if os(macOS)
    Settings {
      SettingsView()
    }
    .windowResizability(.contentSize) // Set window resizability to content size
    .defaultPosition(.center) // Display window in center of screen
#endif

    // MARK: About Window
    /// Display the about window
    Window("About SafeLock", id: "about") {
      AboutView()
    }
    .windowStyle(HiddenTitleBarWindowStyle()) // Set the window style to hidden title bar
    .windowToolbarStyle(UnifiedCompactWindowToolbarStyle()) // Set the window toolbar style
    .windowResizability(.contentSize) // Set window resizability to content size
    .defaultPosition(.center) // Display window in center of screen
  }
}
