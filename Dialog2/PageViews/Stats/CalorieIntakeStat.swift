import SwiftUI

struct CalorieIntakeStatView: View {
    var body: some View {
        VStack {
            Text("Calorie Intake")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Calorie intake tracking feature will be available soon.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Calorie Stats")
        .padding()
    }
}
