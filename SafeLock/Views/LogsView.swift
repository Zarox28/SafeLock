// MARK: Imports
import SwiftUI

// MARK: - Logs View
/// The SwiftUI view for displaying logs
struct LogsView: View {
  @ObservedObject var logsManager = LogsManager.shared // Logs manager instance
  
  var body : some View {
    ScrollView(.vertical, showsIndicators: false) {
      ForEach(logsManager.logs.indices, id: \.self) { index in
        HStack {
          Text(logsManager.formattedDate())
            .font(.system(size: 12))
            .foregroundColor(.gray)
          
          Text(LogsManager.shared.logSymbol(type: logsManager.logs[index].type))
            .font(.system(size: 12))
          
          Text(logsManager.logs[index].text)
            .font(.system(size: 12))
            .foregroundColor(logsManager.logColor(type: logsManager.logs[index].type))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        // Add Spacer for additional vertical space between logs
        Spacer()
      }
    }
    .disabled(logsManager.logs.count <= 11) // Disable scroll if logs count is below or equal to 11 (max size)
  }
}
