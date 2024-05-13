// MARK: Imports
import SwiftUI

// MARK: - Main View
/// The main SwiftUI view for the content of the application
struct MainView: View {
  @State var states: Array<String> = ["Disabled", "Recording", "Enabled"] // Alarm state text
  @State var currentState: Int = 0 // Current state
  @State var hasRecorded: Bool = false // Indicates whether recording has been done
  @State var accessGranted: Bool = false // Indicates whether access has been granted
  @State var monitors: Array<Any?> = [] // Monitors
  @State var logs: Array<(text: String, type: Int)> = [] // Logs

  var body: some View {
    VStack {
      // MARK: Header
      VStack(alignment: .trailing) {
        // Alarm state
        HStack {
          Text("Alarm State")
            .bold()
            .font(.largeTitle)
            .padding(.bottom, 3)
        }

        // Display current state
        HStack {
          Text(states[currentState]) // Display current state text
            .padding(.bottom, 1)

          // Display current state icon
          switch currentState {
            case 1:
              Image(systemName: "circle.dashed")
                .foregroundColor(.orange)
            case 2:
              Image(systemName: "circle.fill")
                .foregroundColor(.green)
            default:
              Image(systemName: "circle")
                .foregroundColor(.red)
          }
        }
      }
      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
      .padding()

      // MARK: Main content
      HStack(spacing: 10) {
        // Display video player based on state
        VStack {
          VideoPlayerView(
            currentState: $currentState,
            hasRecorded: $hasRecorded,
            logs: $logs,
            accessGranted: $accessGranted)
        }
        .frame(maxWidth: .infinity)

        Divider()
          .frame(height: 230)

        // Display logs view
        VStack {
          LogsView(logs: $logs)
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 5)
      }
      .frame(maxHeight: .infinity)

      // MARK: Footer
      /// Toggle alarm button
      HStack {
        switch currentState {
          case 1, 2:
            Button("Disable", action: {
              stopMonitors()
              if currentState == 1 { stopRecording() }

              currentState = 0 // Set current state to disabled
              LogsView(logs: $logs).addLog(text: "Alarm disabled", type: 0) // Show message when disabled
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent).tint(.red)
          default:
            Button("Enable", action: {
              if hasRecorded { hasRecorded = false } // Reset hasRecorded
              lockScreen()
              startMouseMonitoring()

              currentState = 2 // Set current state to enabled
              LogsView(logs: $logs).addLog(text: "Alarm enabled", type: 0) // Show message when enabled
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent).tint(.primary)
        }
      }
      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
      .padding(.top, 5)
    }
    .padding().ignoresSafeArea()
    .frame(width: 600, height: 400)
    .background(BlurBackground().ignoresSafeArea()) // Apply blurred background
    .onAppear {
      LogsView(logs: $logs).addLog(text: "App loaded successfully", type: 1) // Show message when loaded
      requestAccess() // Request access to screen recording
    }
  }
}
