import SwiftUI

struct GlucoseStatsView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var time: Date = Date()
    @State private var toDate: Date = Date()
    
    // ObservedObject wrapper allows the view page to observe and display changes glucoseData
    @ObservedObject var glucoseData = GlucoseData()
    
    var body: some View {
        VStack(spacing: 0) {
            // header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Blood Sugar Statistics")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }
            
// MARK: date range pickers
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your blood sugar data...")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("From:")
                        DatePicker("", selection: $fromDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("To:")
                        DatePicker("", selection: $toDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
            .padding()

            // MARK: - Glucose Trend Graph
            Text("Glucose Trend")
                .font(.headline)
                .foregroundColor(.blue)

            GraphView(data: glucoseData.dailyGlucoseLevels) // Reuse GraphView
                .frame(height: 200)
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)

            // MARK: - Measurements List
            Text("Glucose Measurements")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top)

            List {
                ForEach(glucoseData.dailyGlucoseLevels.indices, id: \.self) { index in
                    Text("Reading \(index + 1): \(String(format: "%.2f", glucoseData.dailyGlucoseLevels[index])) mmol/L")
                        .padding(5)
                }
            }
            .padding()
            
// MARK: bottom blue bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y:40)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    GlucoseStatsView()
}

