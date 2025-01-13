// Model to store user data, in order to be called in other files

import SwiftUI

// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
class UserData: ObservableObject {
    // Dictionary of log entries, keyed by date (formatted as String)
    @Published var logs: [String: LogEntry] = [:]
}

// Represents a single log entry
struct LogEntry {
    let date: String                 // Date of the log (e.g., "2025-01-13")
    let time: String                 // Time of the log (e.g., "13:45")
    let bloodSugarLevel: String      // Recorded blood sugar level
    let note: String                 // Additional notes or observations
    let food: String                 // Food consumed
    let portionSize: String          // Portion size of the food
    let carbohydrateIntake: String   // Carbohydrate intake in grams
}
/* end of reference 1 */
