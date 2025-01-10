import SwiftUI

struct QuestionPage: View {
    // State variables to hold the user's answers for each question
    @State private var answers: [Int] = Array(repeating: 0, count: 10)

    // Options for the multiple-choice answers
    let options = ["Never", "Rarely", "Sometimes", "Often", "Very often"]

    // List of questions
    let questions = [
        "How often do you experience frequent urination?",
        "How often do you feel excessively thirsty?",
        "Have you experienced any unexplained weight loss?",
        "How frequently do you feel extreme hunger?",
        "How often have you noticed sudden changes in your vision?",
        "How often do you experience tingling or numbness in your hands or feet?",
        "How often do you feel very tired much of the time?",
        "How often do you experience very dry skin?",
        "How often do you notice sores that are slow to heal?",
        "How often do you experience more infections than usual?"
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Top Blue Header
                ZStack {
                    Color("Primary_Color")
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 80)

                    Text("Symptom Assessment")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,20)
                }

                // MARK: - Questionnaire
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<questions.count, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(index + 1). \(questions[index])")
                                    .font(.body)
                                    .fontWeight(.regular)

                                // Multiple-choice options
                                ForEach(0..<options.count, id: \.self) { optionIndex in
                                    HStack {
                                        RadioButton(isSelected: answers[index] == optionIndex)
                                            .onTapGesture {
                                                answers[index] = optionIndex
                                            }

                                        Text(options[optionIndex])
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }

                // MARK: - Submit Button
                VStack {
                    Button(action: {
                        // Handle the submit action
                        print("User's answers: \(answers)")
                    }) {
                        Text("SUBMIT")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color("Primary_Color"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 2)
                    }
                }
                .padding()
                .background(Color("Primary_Color"))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - RadioButton Component
struct RadioButton: View {
    var isSelected: Bool

    var body: some View {
        Circle()
            .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 12, height: 12)
            )
    }
}

// MARK: - Preview
struct QuestionPage_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPage()
    }
}
