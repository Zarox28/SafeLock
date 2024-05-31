// MARK: Imports
import SwiftUI

// MARK: - Main View
/// The main SwiftUI view for the content of the application
struct MainView: View {
  @State var states: Array<String> = ["Disabled", "Recording", "Enabled"] // Alarm state text
  
  @ObservedObject var logsManager = LogsManager.shared
  @ObservedObject var cameraManager = CameraManager.shared
  @ObservedObject var global = Global.shared
  @ObservedObject var monitorsManager = MonitorsManager.shared

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
            Text(states[global.currentState]) // Display current state text
              .padding(.bottom, 1)

            // Display current state icon
            switch global.currentState {
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
          VideoPlayerView()
        }
        .frame(maxWidth: .infinity)

        Divider()
          .frame(height: 230)

        // Display logs view
        VStack {
          LogsView()
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 5)
      }
      .frame(maxHeight: .infinity)

      // MARK: Footer
      /// Toggle alarm button
      HStack {
        // Settings Button
        SettingsLink(label: {
            Image(systemName: "gear")
        })
        .controlSize(.large)
        
        // Spacing
        Spacer()
        
        // Toggle Button
        switch global.currentState {
          case 1, 2:
            Button("Disable", action: {
              monitorsManager.stopMonitors()
              if global.currentState == 1 { cameraManager.stopRecording() }

              global.currentState = 0 // Set current state to disabled
              logsManager.addLog(text: "Alarm disabled", type: 0) // Show message when disabled
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent).tint(.red)
          default:
            Button("Enable", action: {
              if cameraManager.hasRecorded { cameraManager.hasRecorded = false } // Reset hasRecorded
              global.lockScreen()
              monitorsManager.startMouseMonitoring()

              global.currentState = 2 // Set current state to enabled
              logsManager.addLog(text: "Alarm enabled", type: 0) // Show message when enabled
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent).tint(.primary)
        }
      }
      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
    }
    .padding().ignoresSafeArea()
    .frame(width: 600, height: 400)
    .background(BlurBackground().ignoresSafeArea()) // Apply blurred background
    .onAppear {
      logsManager.addLog(text: "App loaded successfully", type: 1) // Show message when loaded
      global.requestAccess() // Request access to screen recording
    }
  }
}
