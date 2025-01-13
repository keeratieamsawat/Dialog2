import Foundation
import SwiftUI

class QuestionnaireViewModel: ObservableObject {
    @Published var questions: [Question] = [
        Question(text: "How often do you experience frequent urination?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you feel excessively thirsty?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "Have you experienced any unexplained weight loss?", options: ["No", "Yes"]),
        Question(text: "How frequently do you feel extreme hunger?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often have you noticed sudden changes in your vision?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you experience tingling or numbness in your hands or feet?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you feel very tired much of the time?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you experience very dry skin?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you notice sores that are slow to heal?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]),
        Question(text: "How often do you experience more infections than usual?", options: ["Never", "Rarely", "Sometimes", "Often", "Very often"])
    ]
    
    @Published var answers: [UUID: String] = [:]
    @Published var submissionStatus: String?

    func submitQuestionnaire() {
        guard let token = TokenManager.getToken() else {
            self.submissionStatus = "Error: User not authenticated."
            return
        }

        guard let userID = TokenManager.getUserID() else {
            self.submissionStatus = "Error: Unable to retrieve user ID from token."
            return
        }

        // Ensure all questions have answers
        if answers.count < questions.count {
            self.submissionStatus = "Error: Please answer all questions before submitting."
            return
        }

        // Convert answers to QuestionAnswer objects
        let questionAnswers = answers.map { QuestionAnswer(question_id: $0.key.uuidString, answer: $0.value) }
        let payload = QuestionnairePayload(userid: userID, answers: questionAnswers)

        // Debugging: Print the payload being sent
        do {
            let jsonData = try JSONEncoder().encode(payload)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON Payload: \(jsonString ?? "nil")")
        } catch {
            print("Failed to encode payload: \(error)")
        }

        // Send API request
        APIService.shared.post(
            endpoint: "http://127.0.0.1:5000/questionnaire",
            payload: payload,
            token: token,
            responseType: Response.self
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.submissionStatus = response.success ? "Questionnaire submitted successfully!" : "Submission failed: \(response.message)"
                case .failure(let error):
                    self?.submissionStatus = "Error: \(error.localizedDescription)"
                    print("Error during submission: \(error.localizedDescription)") // Debugging log
                }
            }
        }
    }
}
