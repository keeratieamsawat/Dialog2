import Foundation

// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com

// MARK: - DateUtils Struct
// DateUtils is a utility struct that provides methods for formatting and managing Date objects.
// It includes methods for obtaining timestamps, formatting dates, and formatting times using specific date and time formats.

struct DateUtils {
    
    // MARK: - Current Timestamp
    // This function returns the current date and time formatted as a string (e.g., "2023-01-13T12:34:56Z").
    static func currentTimestamp() -> String {
        let formatter = ISO8601DateFormatter() 
        return formatter.string(from: Date()) // Converts the current date to an ISO 8601 string
    }
    
    // MARK: - Formatted Date
    // This function converts a Date object into "MMM d, yyyy" (e.g., "Jan 13, 2023") format, which is a string format.
    // The Gregorian calendar and UTC timezone are used to ensure consistency in date formatting.
    static func formattedDate(from date: Date, format: String = "MMM d, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)  // Use the Gregorian calendar for formatting
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // Set the timezone to UTC (zero offset)
        return formatter.string(from: date)  // Convert the date to a formatted string
    }

    // MARK: - Formatted Time
    // This function formats a Date object into a time string based on a specified format (default: "HH:mm" for hours and minutes).
    // Similar to the 'formattedDate' method, this also uses the Gregorian calendar and UTC timezone.
    static func formattedTime(from time: Date, format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format    // Set the custom time format (default: "HH:mm")
        formatter.calendar = Calendar(identifier: .gregorian)  // Use the Gregorian calendar for formatting
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // Set the timezone to UTC (zero offset)
        return formatter.string(from: time)  // Convert the time to a formatted string
    }
}

// * end of reference 1

