import Foundation

// Represents a single questionnaire question and its options
struct Question: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
}


// Represents the user's answer to a question
struct QuestionAnswer: Codable {
    let question_id: String // Changed to String to match backend
    let answer: String
}

// Payload for submitting the questionnaire
struct QuestionnairePayload: Codable {
    let userid: String
    let answers: [QuestionAnswer]
}
