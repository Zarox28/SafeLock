// MARK: Imports
import SwiftUI

// MARK: - Logs Manager Class
/// Logs manager class that controls logs
class LogsManager: ObservableObject {
  static let shared = LogsManager() // Singleton instance

  private init() {} // Private initializer

  // MARK: Logs Variable
  /// Array of logs
  @Published private var _logs: Array<(text: String, type: Int)> = []
  var logs: Array<(text: String, type: Int)> {
    return _logs
  }

  // MARK: Add Log Function
  /// Adds a new log message to the existing log text
  func addLog(text: String, type: Int) -> Void {
    DispatchQueue.main.async {
      self._logs.append((text: text, type: type))
    }
  }

  // MARK: Formatted Date Function
  /// Formats the date for logs
  func formattedDate() -> String {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "dd-MM-yy HH:mm"

    return dateFormatter.string(from: Date())
  }

  // MARK: Log Symbol Function
  /// Determines the symbol based on log type
  func logSymbol(type: Int) -> String {
    switch type {
      case 1: return "✅" // Success
      case 2: return "⚠️" // Warning
      case 3: return "❌" // Error
      default: return "ℹ️" // Info
    }
  }

  // MARK: Log Color Function
  /// Determines the color based on log type
  func logColor(type: Int) -> Color {
    switch type {
      case 1: return .green // Success
      case 2: return .orange // Warning
      case 3: return .red // Error
      default: return .cyan // Info
    }
  }
}
