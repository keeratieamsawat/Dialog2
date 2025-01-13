import SwiftUI

struct QuestionnaireView: View {
    @StateObject private var viewModel = QuestionnaireViewModel()
    
    var body: some View {
        VStack {
            // Title
            Text("Symptom Assessment")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Questions
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading) {
                            Text(question.text)
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            // Answer options
                            ForEach(question.options, id: \.self) { option in
                                HStack {
                                    Button(action: {
                                        viewModel.answers[question.id] = option
                                    }) {
                                        HStack {
                                            Image(systemName: viewModel.answers[question.id] == option ? "largecircle.fill.circle" : "circle")
                                                .foregroundColor(.blue)
                                            Text(option)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                    }
                }
            }

            // Submit Button
            Button(action: {
                viewModel.submitQuestionnaire()
            }) {
                Text("SUBMIT")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)

            // Submission Status
            if let status = viewModel.submissionStatus {
                Text(status)
                    .foregroundColor(status.contains("Error") ? .red : .green)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
    }
}
