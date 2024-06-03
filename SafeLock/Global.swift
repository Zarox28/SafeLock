// MARK: Imports
import SwiftUI
import AVFoundation

// MARK: - Global Class
/// Global class that contains global variables and functions
class Global: ObservableObject {
  static let shared = Global() // Singleton instance

  private init() {} // Private initializer

  // MARK: Access Granted Variable
  /// Indicates whether access has been granted
  @Published private var _accessGranted: Bool = false
  var accessGranted: Bool {
    get {
      return _accessGranted
    }
    set {
      DispatchQueue.main.async {
        self._accessGranted = newValue
      }
    }
  }

  // MARK: Current State Variable
  /// Current state of the application
  @Published private var _currentState: Int = 0
  var currentState: Int {
    get {
      return _currentState
    }
    set {
      _currentState = newValue
    }
  }

  // MARK: Lock Screen Function
  /// Locks the screen
  func lockScreen() -> Void {
    let task = Process()

    task.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
    task.arguments = ["displaysleepnow"]

    do {
      try task.run()
    } catch {
      LogsManager.shared.addLog(text: "Failed to lock screen", type: 3)
    }
  }

  // MARK: Request Access Function
  /// Requests access to the camera
  func requestAccess() -> Void {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      if granted {
        LogsManager.shared.addLog(text: "Access to camera granted", type: 1)
      } else {
        LogsManager.shared.addLog(text: "Access to camera denied", type: 3)
      }

      self.accessGranted = granted
    }
  }
}
