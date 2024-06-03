// MARK: Imports
import SwiftUI

// MARK: - Monitors Manager Class
/// Monitors manager class that controls event monitors
class MonitorsManager: ObservableObject {
  static let shared = MonitorsManager() // Singleton instance

  private init() {} // Private initializer

  // MARK: Monitors Variable
  /// Array of monitors
  @Published private var _monitors: Array<Any?> = []
  var monitors: Array<Any?> {
    return _monitors
  }

  // MARK: Start Mouse Monitoring Function
  /// Starts monitoring mouse movements
  func startMouseMonitoring() -> Void {
    var hasShownMouseMoveMessage = false

    _monitors.append(
      NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
        guard !hasShownMouseMoveMessage else { return }

        LogsManager.shared.addLog(text: "Mouse moved", type: 2)

        do {
          try CameraManager.shared.startRecording()
          hasShownMouseMoveMessage = true
        } catch {
          LogsManager.shared.addLog(text: "Failed to start recording", type: 3)
        }
      }
    )

    LogsManager.shared.addLog(text: "Mouse monitor enabled", type: 0)
  }

  // MARK: Stop Monitors Function
  /// Stops all monitors
  func stopMonitors() -> Void {
    if let monitors = monitors as? [NSObject] {
      for monitor in monitors {
        NSEvent.removeMonitor(monitor)
      }

      self._monitors.removeAll()
      LogsManager.shared.addLog(text: "All Monitors stopped", type: 1)

    } else {
      LogsManager.shared.addLog(text: "Cannot stop monitors", type: 3)
    }
  }
}
