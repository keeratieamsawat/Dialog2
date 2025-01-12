import Foundation

struct DateUtils {
    
    static func currentTimestamp() -> String {
           let formatter = ISO8601DateFormatter()
           return formatter.string(from: Date())
       }
    

    
    /// Formats a ⁠ Date ⁠ into a string using the specified format and the Gregorian calendar.
    static func formattedDate(from date: Date, format: String = "MMM d, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian) // Use Gregorian calendar
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure UTC
        return formatter.string(from: date)
    }

    /// Formats a ⁠ Date ⁠ into a string for time using the specified format and the Gregorian calendar.
    static func formattedTime(from time: Date, format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian) // Use Gregorian calendar
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure UTC
        return formatter.string(from: time)
    }
}
