import Foundation

// MARK: - Condition Model
// This structure represents a condition with user data and other details
struct Condition: Codable {
    let userIdDataType: String  // User ID and data type concatenated (e.g., "user123#bloodSugar")
    let datatype: String        // The type of data
    let value: String           // The value of the condition
    let date: String            // The date and time when each variable is recorded input by users
    let timestamp: String       // The timestamp when the condition was recorded
}

// MARK: - ConditionsPayload Model
// This structure represents a payload containing user ID and a list of conditions
struct ConditionsPayload: Codable {
    let user_id: String         // The user ID associated with the conditions
    let conditions: [Condition] // A list of conditions associated with the user
}

// MARK: - AlertDoctorResponse Model
// This structure represents the response after alerting the doctor, contains message and status
struct AlertDoctorResponse: Decodable {
    let message: String         // Message from the doctor alert service
    let status: String          // Status of the doctor alert (e.g., "success")
}

// MARK: - ConditionHelper
// A helper structure containing functions to create and prepare conditions and payloads
struct ConditionHelper {
    
    // This function creates a Condition object using provided parameters
    static func createCondition(userId: String, dataType: String, value: String, date: Date, timestamp: String) -> Condition {
        return Condition(
            userIdDataType: "\(userId)#\(dataType)",
            datatype: dataType,
            value: value,
            date: DateUtils.formattedDate(from: date, format: "yyyy-MM-dd'T'HH:mm:ss"), // Format date to a string
            timestamp: timestamp
        )
    }

    // This function prepares a ConditionsPayload object containing the user ID and list of conditions
    static func preparePayload(userId: String, conditions: [Condition]) -> ConditionsPayload {
        return ConditionsPayload(user_id: userId, conditions: conditions) // Returns the conditions payload with user ID and conditions
    }
}

