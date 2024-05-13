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
  @Binding var currentState: Int // Binding to current state
  @Binding var hasRecorded: Bool // Binding for whether recording has been made or not
  @Binding var logs: Array<(text: String, type: Int)> // Binding to logs
  @Binding var accessGranted: Bool // Binding to access granted

  @State var dotVisibilities = [false, false, false] // 3 dots animation

  var body: some View {
    // Check state to determine UI
    if currentState == 0 { // MARK: Disabled
      if hasRecorded {
        VideoViewer(
          player: AVPlayer(
            url: URL(fileURLWithPath: (
              NSTemporaryDirectory() as NSString).appendingPathComponent("webcam.mp4")
            )
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

    } else if currentState == 1 { // MARK: Recording
      Image(systemName: "video")
        .padding(.bottom, 10)
        .font(.system(size: 50))
        .foregroundStyle(.orange)

      Text("Recording")
        .bold()
        .font(.largeTitle)
        .padding(.bottom, 10)
        .onAppear {
          LogsView(logs: $logs).addLog(text: "Recording", type: 2) // Show message when recording
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
          guard accessGranted else { return } // Check access
          LogsView(logs: $logs).addLog(text: "Ready to record", type: 1) // Show message when ready to record
        }
    }
  }
}
