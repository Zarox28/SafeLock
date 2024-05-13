// MARK: Imports
import SwiftUI
import AVFoundation

// MARK: - Main View Extension
/// An extension for the main SwiftUI view for the content of the application
extension MainView {
  // MARK: Start Mouse Monitoring Function
  /// Starts monitoring mouse movements
  func startMouseMonitoring() -> Void {
    var hasShownMouseMoveMessage = false

    monitors.append(
      NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
        guard !hasShownMouseMoveMessage else { return }

        LogsView(logs: $logs).addLog(text: "Mouse moved", type: 2)

        do {
          try startRecording()
          hasShownMouseMoveMessage = true
        } catch {
          LogsView(logs: $logs).addLog(text: "Failed to start recording", type: 3)
        }
      }
    )

    LogsView(logs: $logs).addLog(text: "Mouse monitor enabled", type: 0)
  }

  // MARK: Stop Monitors Function
  /// Stops all monitors
  func stopMonitors() -> Void {
    if let monitors = monitors as? [NSObject] {
      for monitor in monitors {
        NSEvent.removeMonitor(monitor)
      }

      self.monitors.removeAll()
      LogsView(logs: $logs).addLog(text: "All Monitors stopped", type: 1)

    } else {
      LogsView(logs: $logs).addLog(text: "Cannot stop monitors", type: 3)
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
      LogsView(logs: $logs).addLog(text: "Failed to lock screen", type: 3)
    }
  }

  // MARK: Request Access Function
  /// Requests access to the camera
  func requestAccess() -> Void {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      if granted {
        LogsView(logs: $logs).addLog(text: "Access to camera granted", type: 1)
      } else {
        LogsView(logs: $logs).addLog(text: "Access to camera denied", type: 3)
      }

      accessGranted = granted
    }
  }

  // MARK: Start Recording Function
  /// Starts recording the webcam
  func startRecording() throws -> Void {
    let outputFilePath: String = (NSTemporaryDirectory() as NSString).appendingPathComponent("webcam.mp4")

    try? FileManager.default.removeItem(atPath: outputFilePath)

    guard accessGranted else {
      LogsView(logs: $logs).addLog(text: "Access to camera denied", type: 3)
      return
    }

    let task = Process()

    task.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/ffmpeg")
    task.arguments = ["-f", "avfoundation", "-video_size", "640x480", "-framerate", "30", "-i", "0", outputFilePath]
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice

    do {
      try task.run()
    } catch {
      LogsView(logs: $logs).addLog(text: "Failed to start recording", type: 3)
    }

    currentState = 1
  }

  // MARK: Stop Recording Function
  /// Stops recording the webcam
  func stopRecording() -> Void {
    let task = Process()

    task.executableURL = URL(fileURLWithPath: "/usr/bin/pkill")
    task.arguments = ["ffmpeg"]

    do {
      try task.run()
      task.waitUntilExit()

      if task.terminationStatus == 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          LogsView(logs: $logs).addLog(text: "Successfully recorded", type: 1)

          currentState = 0
          hasRecorded = true
        }
        
      } else {
        LogsView(logs: $logs).addLog(text: "Recording failed", type: 3)
      }
      
    } catch {
      LogsView(logs: $logs).addLog(text: "Failed to stop recording", type: 3)
    }
  }
}
