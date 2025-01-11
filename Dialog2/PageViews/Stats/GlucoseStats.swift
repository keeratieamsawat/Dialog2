import SwiftUI

struct GlucoseStatsView: View {
    // Variables to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()
    
    // ObservedObject wrapper allows the view page to observe and display changes in glucoseData
    @ObservedObject var glucoseData = GlucoseData()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Top Blue Bar
                    ZStack {
                        Color("Primary_Color")
                            .frame(height: 120)
                            .edgesIgnoringSafeArea(.top)
                        
                        Text("Blood Sugar Statistics")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 55)
                            .padding(.bottom, 10)
                    }
                    
                    // MARK: - Date Range Pickers
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
                    
                    Spacer()
                    
                    // MARK: - Bottom Blue Bar
                    ZStack {
                        Color("Primary_Color")
                            .frame(height: 80)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Preview
#Preview {
    GlucoseStatsView(glucoseData: GlucoseData())
}
