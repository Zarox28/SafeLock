// MARK: Imports
import SwiftUI
import AVKit

// MARK: - Video player
/// Wraps AVPlayerView using NSViewRepresentable to set custom controls
struct VideoViewer: NSViewRepresentable {
  var player: AVPlayer // Player
  
  // MARK: Create and configure AVPlayerView
  /// This function is called to create and configure the AVPlayerView
  func makeNSView(context: Context) -> AVPlayerView {
    let view = AVPlayerView()
    
    view.player = player
    view.controlsStyle = .inline
    view.allowsVideoFrameAnalysis = false // Disable OCR
    view.updatesNowPlayingInfoCenter = false // Disable now playing
    view.videoGravity = .resizeAspectFill // Resizing
    
    return view
  }
  
  // MARK: Update AVPlayerView
  /// This function is called to update the AVPlayerView if needed
  func updateNSView(_ nsView: AVPlayerView, context: Context) {}
}

// MARK: - Video Player View
/// The SwiftUI view for displaying video player based on the current state
struct VideoPlayerView: View {
  @State var dotVisibilities = [false, false, false] // 3 dots animation
  
  @ObservedObject var logsManager = LogsManager.shared // Logs manager instance
  @ObservedObject var cameraManager = CameraManager.shared // Camera manager instance
  @ObservedObject var global = Global.shared // Global instance
  
  var body: some View {
    // Check state to determine UI
    if global.currentState == 0 { // MARK: Disabled
      if cameraManager.hasRecorded {
        VideoViewer(
          player: AVPlayer(
            url: URL(fileURLWithPath: cameraManager.recordPath)
          )
        )
        .cornerRadius(10)
        
      } else {
        Image(systemName: "video.slash")
          .foregroundStyle(.red, .primary)
          .padding(.bottom, 10)
          .font(.system(size: 50))
        
        Text("No Records")
          .bold()
          .font(.largeTitle)
      }
      
    } else if global.currentState == 1 { // MARK: Recording
      Image(systemName: "video")
        .padding(.bottom, 10)
        .font(.system(size: 50))
        .foregroundStyle(.orange)
      
      Text("Recording")
        .bold()
        .font(.largeTitle)
        .padding(.bottom, 10)
        .onAppear {
          logsManager.addLog(text: "Recording", type: 2) // Show message when recording
        }
      
      // Dots
      HStack(spacing: 10) {
        ForEach(dotVisibilities.indices, id: \.self) { index in
          Circle()
            .fill(Color.orange)
            .frame(width: 10, height: 10)
            .opacity(dotVisibilities[index] ? 1 : 0)
            .onAppear {
              // Animate dot visibility
              withAnimation(Animation.easeInOut(duration: 0.8).repeatForever().delay(Double(index) * 0.2)) {
                dotVisibilities[index].toggle()
              }
            }
        }
      }
      
    } else { // MARK: Ready
      Image(systemName: "video.slash")
        .foregroundStyle(.red, .primary)
        .padding(.bottom, 10)
        .font(.system(size: 50))
      
      Text("No Records")
        .bold()
        .font(.largeTitle)
        .onAppear {
          guard global.accessGranted else { return } // Check access
          logsManager.addLog(text: "Ready to record", type: 1) // Show message when ready to record
        }
    }
  }
}
