//  Displays user statistics such as glucose data, exercises, insulin intake, and food intake. Includes time range selection and navigation to detailed views.

import SwiftUI

struct MyStatisticPage: View {
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    enum StatCardType: Hashable {
        case bloodSugarFluctuations
        case exercisesAndWeight
        case insulinIntake
        case otherMedicine
        case foodIntake
    }
    
    @State private var submissionStatus: String = "" // Add this for error handling
        
    // Computed property to retrieve userID
    private var userID: String {
        guard let id = TokenManager.getUserID() else {
            submissionStatus = "Error: Unable to retrieve user ID from token."
            return "7808aba7-6ae4-4603-a408-560308d08ecc"
        }
        return id
    }

    class GlucoseData: ObservableObject {
        @Published var data: [[String: Any]] = []  // Array of dictionaries to store glucose data
        
        // Reference 2 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
        func calculateAverage() -> Double {
            let totalValue = data.reduce(0) { (sum, item) in
                // Safely unwrap and convert the 'value' to Double
                let value = item["value"] as? Double ?? 0.0
                return sum + value
            }
            let average = data.isEmpty ? 0.0 : totalValue / Double(data.count)
            return average
        }
    }
    
    @StateObject var glucoseData: GlucoseData = GlucoseData() // Shared data model for glucose statistics
    @State private var fromDate = Date()
    @State private var fromTime = Date()
    @State private var toDate = Date()
    @State private var toTime = Date()
    
    // State to track which card is active for navigation
    @State private var activeCard: StatCardType? = nil
    
    var body: some View {
        NavigationView() {
            VStack(spacing: 0) {
                // MARK: - Header Section
                ZStack {
                    Color("Primary_Color")
                        .frame(maxWidth:.infinity, maxHeight: 100)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack(spacing:10) {
                        Text("My Statistics")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(-50)
                    }
                }
                
                // MARK: - Time Range Picker
                VStack(alignment:.leading,spacing: 15) {
                    Text("Choose a time range...")
                        .font(.headline)
                        .padding(.leading)
                        .offset(y:-60)
                    
                    // "From" Section
                    HStack {
                        Text("From")
                            .font(.subheadline)
                            .frame(width: 50, alignment: .leading)
                            .padding(10)
                        
                        DatePicker("", selection: $fromDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding(.horizontal)
                        
                        DatePicker("", selection: $fromTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .offset(y:-60)
                    
                    // "To" Section
                    HStack {
                        Text("To")
                            .font(.subheadline)
                            .frame(width: 50, alignment: .leading)
                            .padding(10)
                        
                        DatePicker("", selection: $toDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding(.horizontal)
                        
                        DatePicker("", selection: $toTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding(.horizontal)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .offset(y:-60)
                }
                .padding()
                
                // MARK: - Stat Buttons
                ScrollView {
                    VStack(spacing: 15) {
                        // Blood Sugar Fluctuations
                        Button(action: {
                            callFetchData(for: .bloodSugarFluctuations)
                        }) {
                            StatCard(
                                icon: "chart.bar",
                                title: "Blood Sugar Fluctuations",
                                description: "See your blood sugar fluctuation trends during the chosen time period."
                            )
                        }
                        
                        // Exercises & Change in Weight
                        Button(action: {
                            activeCard = .exercisesAndWeight
                        }) {
                            StatCard(
                                icon: "figure.walk",
                                title: "Exercises & Change in Weight",
                                description: "Keeping a record of physical exercises you’ve done and any weight changes."
                            )
                        }
                        
                        // Insulin Intake
                        Button(action: {
                            activeCard = .insulinIntake
                        }) {
                            StatCard(
                                icon: "pencil.tip.crop.circle",
                                title: "Insulin Intake",
                                description: "Check your detailed insulin intake - type of insulin and dose."
                            )
                        }
                        
                        // Other Medicine
                        Button(action: {
                            activeCard = .otherMedicine
                        }) {
                            StatCard(
                                icon: "pills.fill",
                                title: "Other Medicine",
                                description: "Other types of medicine you have taken - name and dose."
                            )
                        }
                        
                        // Food Intake
                        Button(action: {
                            activeCard = .foodIntake
                        }) {
                            StatCard(
                                icon: "cart.fill",
                                title: "Food Intake",
                                description: "It is of utmost importance to eat properly!"
                            )
                        }
                        
                        // Hidden NavigationLinks
                        // Reference 3 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
                        NavigationLink(
                            destination: MeasuredStatView(glucoseData: glucoseData),
                            tag: .bloodSugarFluctuations,
                            selection: $activeCard
                        ) { EmptyView() }
                        NavigationLink(
                            destination: ExerciseStatView(),
                            tag: .exercisesAndWeight,
                            selection: $activeCard
                        ) { EmptyView() }
                        NavigationLink(
                            destination: InsulinStatView(),
                            tag: .insulinIntake,
                            selection: $activeCard
                        ) { EmptyView() }
                        NavigationLink(
                            destination: MedicationStatView(),
                            tag: .otherMedicine,
                            selection: $activeCard
                        ) { EmptyView() }
                        NavigationLink(
                            destination: CalorieIntakeStatView(),
                            tag: .foodIntake,
                            selection: $activeCard
                        ) { EmptyView() }
                    }
                    .padding(15)
                }
                .offset(y: -60)
                
                Button(action: {
                    print("Email statistics to doctor tapped")
                }) {
                    Text("Email My Statistics to my doctor")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .padding()
                .offset(y: -40)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Fetch Data
    private func callFetchData(for card: StatCardType) {
        print("Fetching data for \(card)")
        let data: [String: String] = [
            "userid": userID,
            "fromDate": JSONUtils.combineDateAndTimeAsString(date: fromDate, time: fromTime),
            "toDate": JSONUtils.combineDateAndTimeAsString(date: toDate, time: toTime)
        ]
        JSONUtils.fetchData(Data: data) { result in
            DispatchQueue.main.async {
                if let result = result {
                    print("Fetched data: \(result)")
                    glucoseData.data = result
                    activeCard = card
                } else {
                    print("Failed to fetch data.")
                }
            }
        }
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
//    // MARK: - Preview
    struct MyStatisticPage_Previews: PreviewProvider {
        static var mockGlucose: MyStatisticPage.GlucoseData {
            let glucoseData = MyStatisticPage.GlucoseData()
    //        glucoseData.data = [
    //            ["date": "2024-12-08T13:59:00", "value": 80.0],
    //            ["date": "2024-12-31T17:00:00", "value": 100.0],
    //            ["date": "2025-01-11T06:53:07", "value": 58.0]
    //        ]
            glucoseData.data = [
                        ["date": "2025-01-13T13:59:00", "value": 80.0],
                        ["date": "2025-01-13T15:00:00", "value": 80.0]
                        ]
            return glucoseData
        }
        static var previews: some View {
            MyStatisticPage(glucoseData: mockGlucose)
        }
    }


