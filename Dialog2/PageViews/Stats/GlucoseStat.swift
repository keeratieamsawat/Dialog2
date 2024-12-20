// Shared glucose data model
import SwiftUI

// MARK: - GlucoseStatView
struct GlucoseStatView: View {
    @ObservedObject var glucoseData: GlucoseData // Shared data model

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Page Title
            Text("Glucose Statistics")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // MARK: - Glucose Trend Graph
            Text("Glucose Trend")
                .font(.headline)
                .foregroundColor(.blue)

            GraphView(data: glucoseData.dailyGlucoseLevels) // Reuse GraphView
                .frame(height: 200)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            // MARK: - Measurements List
            Text("Glucose Measurements")
                .font(.headline)
                .padding(.top)

            List {
                ForEach(glucoseData.dailyGlucoseLevels.indices, id: \.self) { index in
                    Text("Reading \(index + 1): \(String(format: "%.2f", glucoseData.dailyGlucoseLevels[index])) mmol/L")
                        .padding(5)
                }
            }
            .frame(maxHeight: 300)

            Spacer()
        }
        .padding()
        .navigationTitle("Glucose Statistics")
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

