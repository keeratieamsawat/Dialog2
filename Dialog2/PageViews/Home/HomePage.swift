//  The main home page for the app, showing glucose levels, metrics, and navigation options
//  Includes a graph for daily glucose levels and links to key app features

import SwiftUI

struct HomePageView: View {
    @State private var currentDate = Date() // Update in real time
    @State private var selectedLogMode: String = "Simple" // Mode selection
    // Shared data model (for glucose level graph)
    @StateObject var glucoseDataDefault: MyStatisticPage.GlucoseData = MyStatisticPage.GlucoseData()

    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Top Blue Bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 140)
                        .edgesIgnoringSafeArea(.top)

                    Text(formattedDate(currentDate))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 55)
                        .padding(.bottom, -50)
                }

                // MARK: - Log Mode Picker
                Picker("Log Mode", selection: $selectedLogMode) {
                    Text("Simple").tag("Simple")
                    Text("Comprehensive").tag("Comprehensive")
                    Text("Intensive").tag("Intensive")
                }
                .pickerStyle(SegmentedPickerStyle())
                .font(.headline)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)

                // MARK: - Daily Glucose Graph
                NavigationLink(destination: GlucoseStatView(glucoseDataDefault: glucoseDataDefault)) {
                    VStack {
                        Text("Blood glucose levels today")
                            .font(.headline)
                            .foregroundColor(Color("Primary_Color"))
                            .padding(.top, 10)
                        
                        if glucoseDataDefault.data.isEmpty {
                            Text("No data available")
                                .frame(width: 350, height: 230)
                                .foregroundColor(.gray)
                                .font(.headline)
                                .onAppear {
                                    let currentDate = Date()
                                    
                                    // Get formatted strings for both dates
                                    let formattedCurrentDate = JSONUtils.getFormattedDate(for: currentDate)
                                    let Data: [String: String] = [
                                        "fromDate": formattedCurrentDate,
                                        "toDate": formattedCurrentDate
                                    ]
                                    JSONUtils.fetchData(Data: Data) { result in
                                        DispatchQueue.main.async {
                                            if let result = result {
                                                print("Fetched data: \(result)")
                                                glucoseDataDefault.data = result // Update data on the main thread
                                                if glucoseDataDefault.data.count == 1 {
                                                    glucoseDataDefault.data.append(["date": Date(), "value": glucoseDataDefault.data[0]["value"]!])
                                                }
                                            }else {
                                                print("Failed to fetch data.")
                                            }
                                        }
                                    }
                                }
                        } else {
                            GraphView(data: glucoseDataDefault.data)
                                .frame(height: 300)
                                .padding()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }

                // MARK: - Key Metrics
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: MeasuredStatView(glucoseData: glucoseDataDefault)) {
                            MetricCard(title: "Measured", value: "\(glucoseDataDefault.data.count) time(s)")
                        }
                        NavigationLink(destination: AverageStatView(glucoseData: glucoseDataDefault)) {
                            MetricCard(title: "Average", value: "\(String(format: "%.2f", glucoseDataDefault.calculateAverage())) mmol/L")
                        }
                        NavigationLink(destination: CarbIntakeStatView()) {
                            MetricCard(title: "Carb Intake", value: "20 g")
                        }
                    }
                    HStack(spacing: 20) {
                        NavigationLink(destination: MedicationStatView()) {
                            MetricCard(title: "Medication Intake", value: "500 mg")
                        }
                        NavigationLink(destination: ExerciseStatView()) {
                            MetricCard(title: "Exercise", value: "30 min")
                        }
                        NavigationLink(destination: CalorieIntakeStatView()) {
                            MetricCard(title: "Calorie Intake", value: "1500 kcal")
                        }
                    }
                }
                .padding(.top)

                // MARK: - Record Button
                NavigationLink(destination: destinationView(for: selectedLogMode)) {
                    Text("RECORD")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 120)
                        .background(Color("Primary_Color"))
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.top)

                Spacer()

                // MARK: - Navigation Tabs and Bottom Blue Section
                VStack(spacing: 0) {
                    HStack {
                        NavigationLink(destination: MyStatisticPage()) {
                            TabItem(icon: "chart.bar", label: "Stats")
                        }
                        NavigationLink(destination: HomePageView()) {
                            TabItem(icon: "house.fill", label: "Home", isSelected: true)
                        }
                        NavigationLink(destination: MyInfoPage()) {
                            TabItem(icon: "person.fill", label: "Me")
                        }
                        NavigationLink(destination: QuestionnaireView()) {
                            TabItem(icon: "doc.text", label: "Questions")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray5))

                    ZStack {
                        Color("Primary_Color")
                            .frame(height: 80)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }

    // MARK: - Helper Function to Format Date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }

    // MARK: - Helper Function to Determine Destination View
    @ViewBuilder
    func destinationView(for mode: String) -> some View {
        switch mode {
        case "Simple":
            SimpleMethodView()
        case "Comprehensive":
            ComprehensiveMethodView()
        case "Intensive":
            IntensiveView()
        default:
            Text("Unknown Mode")
        }
    }
}

// MARK: - Metric Card Component
struct MetricCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("Primary_Color"))
        }
        .frame(width: 100, height: 80)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

// MARK: - Tab Item Component
struct TabItem: View {
    let icon: String
    let label: String
    var isSelected: Bool = false

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : .gray)
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
struct HomePageView_Previews: PreviewProvider {
    static var mockGlucose: MyStatisticPage.GlucoseData {
        let glucoseData = MyStatisticPage.GlucoseData()
//        glucoseData.data = [
//            ["date": "2024-12-08T13:59:00", "value": 80.0],
//            ["date": "2024-12-31T17:00:00", "value": 100.0],
//            ["date": "2025-01-11T06:53:07", "value": 58.0]
//        ]
        glucoseData.data = [
                    
                    ]
        return glucoseData
    }

    static var previews: some View {
        HomePageView(glucoseDataDefault: mockGlucose)
    }
}
