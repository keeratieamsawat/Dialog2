
// data model here to store user data, and they can be called in other files
import SwiftUI
//import Foundation

class UserData: ObservableObject {
    // create a dictionary called "logs", keyed by dates which are formatted as String
    @Published var logs: [String: LogEntry] = [:]
}

// log entries for data logged in simple method
struct LogEntry {
    let date: String
    let time: String
    let bloodSugarLevel: String
    let note: String
    let food: String
    let portionSize: String
    let carbohydrateIntake: String
}
