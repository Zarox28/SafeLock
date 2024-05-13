// MARK: Imports
import SwiftUI

// MARK: - Logs View
/// The SwiftUI view for displaying logs
struct LogsView: View {
  @Binding var logs: Array<(text: String, type: Int)> // Binding for logs

  var body : some View {
    ScrollView(.vertical, showsIndicators: false) {
      ForEach(logs.indices, id: \.self) { index in
        HStack {
          Text(formattedDate())
            .font(.system(size: 12))
            .foregroundColor(.gray)

          Text(logSymbol(type: logs[index].type))
            .font(.system(size: 12))

          Text(logs[index].text)
            .font(.system(size: 12))
            .foregroundColor(logColor(type: logs[index].type))
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        // Add Spacer for additional vertical space between logs
        Spacer()
      }
    }
    .disabled(logs.count <= 11) // Disable scroll if logs count is below or equal to 11 (max size)
  }
}
