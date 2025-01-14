//  The main home page for the app, showing glucose levels, metrics, and navigation options
//  Includes a graph for daily glucose levels and links to key app features

import SwiftUI

struct HomePageView: View {
    @State private var currentDate = Date() // Update in real time
    @State private var selectedLogMode: String = "Simple" // Mode selection
    // Shared data model (for glucose level graph)
    @StateObject var glucoseDataDefault: MyStatisticPage.GlucoseData = MyStatisticPage.GlucoseData()
    @State private var isLoading = true
    @State private var carbohydrateIntake = 0
    @State private var dosage = 0
    @State private var duration = 0
    @State private var caloriesIntake = 0
    @State private var submissionStatus: String = "" // for error handling
        
    // Computed property to retrieve userID
    private var userID: String {
        guard let id = TokenManager.getUserID() else {
            submissionStatus = "Error: Unable to retrieve user ID from token."
            return "7808aba7-6ae4-4603-a408-560308d08ecc"
        }
        return id
    }
            

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
                        
                        if isLoading {
                            // Show a loading indicator while fetching data
                            ProgressView("Loading...")
                                .frame(width: 350, height: 300)
                                .padding()
                        } else if glucoseDataDefault.data.isEmpty {
                            Text("No data available")
                                .frame(width: 350, height: 280)
                                .foregroundColor(.gray)
                                .font(.headline)
                        } else {
                            // Render GraphView only when data is available
                            GraphView(data: glucoseDataDefault.data)
                                .frame(height: 280)
                                .padding()
                        }
                    }
                .onAppear {
                        isLoading = true // Reset loading state
                    
                        // Fetch data every time the view appears
                        // Get today's date
                        let today = Date()

                        // Get the current calendar
                        let calendar = Calendar.current

                        // Get the current date without the time component
                        let currentDate = calendar.startOfDay(for: today)
//                            let currentDate = Date()
                        let formattedCurrentDate = JSONUtils.getFormattedDateHome(for: currentDate)
                        let Data: [String: String] = [
                            "userid": userID,
                            "fromDate": "\(formattedCurrentDate)T00:00",
                            "toDate": "\(formattedCurrentDate)T23:59"
                        ]
                        JSONUtils.fetchData(Data: Data) { result in
                            DispatchQueue.main.async {
                                if let result = result {
                                    print("Fetched data: \(result)")
                                    glucoseDataDefault.data = result // Update data on the main thread
                                } else {
                                    print("Failed to fetch data.")
                                }
                                isLoading = false
                            }
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
                            MetricCard(title: "Carb Intake", value: "\(carbohydrateIntake) g")
                        }
                    }
                    HStack(spacing: 20) {
                        NavigationLink(destination: MedicationStatView()) {
                            MetricCard(title: "Medication Intake", value: "\(dosage) mg")
                        }
                        NavigationLink(destination: ExerciseStatView()) {
                            MetricCard(title: "Exercise", value: "\(duration) min")
                        }
                        NavigationLink(destination: CalorieIntakeStatView()) {
                            MetricCard(title: "Calorie Intake", value: "\(caloriesIntake) kcal")
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
                        .frame(width: 170, height: 90)
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
        glucoseData.data = [
            ["date": "2024-12-08T13:59:00", "value": 80.0],
            ["date": "2025-01-11T06:53:07", "value": 58.0]
        ]
        return glucoseData
    }

    static var previews: some View {
        HomePageView(glucoseDataDefault: mockGlucose)
    }
}

