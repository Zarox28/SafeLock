// MARK: Imports
import AVFoundation

// MARK: - Camera Manager Class
/// Camera manager class that controls the webcam
class CameraManager: ObservableObject {
  static let shared = CameraManager() // Singleton instance
  
  private init() {} // Private initializer
  
  // MARK: Has Recorded Variable
  /// Indicates whether recording has been done
  @Published private var _hasRecorded: Bool = false
  var hasRecorded: Bool {
    get {
      return _hasRecorded
    }
    set {
      _hasRecorded = newValue
    }
  }
  
  // MARK: Record Path
  /// Path to the recorded video
  @Published private var _recordPath: String = (NSTemporaryDirectory() as NSString).appendingPathComponent("webcam.mp4")
  var recordPath: String {
    return _recordPath
  }
  
  // MARK: Start Recording Function
  /// Starts recording the webcam
  func startRecording() throws -> Void {
    if hasRecorded { removeRecord() } // Remove previous video file if it exists
    
    guard Global.shared.accessGranted else {
      LogsManager.shared.addLog(text: "Access to camera denied", type: 3)
      return
    }
    
    let task = Process()
    
    task.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/ffmpeg")
    task.arguments = ["-f", "avfoundation", "-video_size", "640x480", "-framerate", "30", "-i", "0", recordPath]
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice
    
    do {
      try task.run()
    } catch {
      LogsManager.shared.addLog(text: "Failed to start recording", type: 3)
    }
    
    Global.shared.currentState = 1
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
          LogsManager.shared.addLog(text: "Successfully recorded", type: 1)
          
          Global.shared.currentState = 0
          CameraManager.shared.hasRecorded = true
        }
        
      } else {
        LogsManager.shared.addLog(text: "Recording failed", type: 3)
      }
      
    } catch {
      LogsManager.shared.addLog(text: "Failed to stop recording", type: 3)
    }
  }
  
  // MARK: Remove Record
  /// Removes the recorded video
  func removeRecord() -> Void {
    do {
      try FileManager.default.removeItem(atPath: recordPath)
    } catch {
      LogsManager.shared.addLog(text: "Failed to remove record", type: 3)
    }
  }
}
