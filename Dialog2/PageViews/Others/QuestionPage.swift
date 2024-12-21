import SwiftUI

struct QuestionPage: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Questionnaire")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("This page will display the questionnaire for users.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Questionnaire")
        .padding()
    }
}
