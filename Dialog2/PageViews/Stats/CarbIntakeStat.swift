import SwiftUI

struct CarbIntakeStatView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Carb Intake Statistics")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Chen fix this") // Placeholder text
                .font(.headline)
                .foregroundColor(.gray) 
                .padding()

            Spacer()
        }
        .navigationTitle("Carb Intake Stats")
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}
