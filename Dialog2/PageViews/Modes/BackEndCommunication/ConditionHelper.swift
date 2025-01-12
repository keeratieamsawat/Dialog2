import Foundation

struct Condition: Codable {
    let userIdDataType: String
    let datatype: String
    let value: String
    let date: String
    let timestamp: String
}

struct ConditionsPayload: Codable {
    let user_id: String
    let conditions: [Condition]
}

struct AlertDoctorResponse: Decodable {
    let message: String
    let status: String
}




struct ConditionHelper {
    // Helper function to create a condition
    static func createCondition(userId: String, dataType: String, value: String, date: Date, timestamp: String) -> Condition {
        return Condition(
            userIdDataType: "\(userId)#\(dataType)",
            datatype: dataType,
            value: value,
            date: DateUtils.formattedDate(from: date, format: "yyyy-MM-dd'T'HH:mm:ss"),
            timestamp: timestamp
        )
    }

    // Helper function to prepare the payload
    static func preparePayload(userId: String, conditions: [Condition]) -> ConditionsPayload {
        return ConditionsPayload(user_id: userId, conditions: conditions)
    }
}
