import SwiftUI

struct HomePageView: View {
    // Update in real time
    @State private var currentDate = Date()
    
    // Mode selection
    @State private var selectedLogMode: String = "Simple"
    
    // Shared data model (glucose level graph)
    @ObservedObject var glucoseData = GlucoseData()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Top Section (Date and Log Mode Selection)
                ZStack {
                    Color("Primary_Color")
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .edgesIgnoringSafeArea(.top)

                    VStack(spacing: 10) {
                        Text(formattedDate(currentDate))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, -10)

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

                    }
                }

                // MARK: - Daily Glucose Graph (Linked to MyStatistic Page)
                NavigationLink(destination: GlucoseStatView(glucoseData: glucoseData)) {
                    VStack {
                        Text("Average Glucose Level Per Hour")
                            .font(.headline)
                            .foregroundColor(Color("Primary_Color"))
                            .padding(.top, 10)
                        
                        GraphView(data: glucoseData.dailyGlucoseLevels)
                            .frame(height: 170)
                            .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }

                // MARK: - Key Metrics
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: MeasuredStatView(glucoseData: glucoseData)) {
                            MetricCard(title: "Measured", value: "\(glucoseData.dailyGlucoseLevels.count) times")
                        }
                        
                        NavigationLink(destination: AverageStatView(glucoseData: glucoseData)) {
                            MetricCard(title: "Average", value: "\(String(format: "%.2f", glucoseData.calculateAverage())) mmol/L")
                        }

                        NavigationLink(destination: CarbIntakeStatView()) { // Placeholder
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

                // MARK: - Record Button Navigation (Different Mode)
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

                // MARK: - Navigation Tabs and Blue Bottom Section
                VStack(spacing: 0) {
                    HStack {
                        NavigationLink(destination: MyStatisticPage(glucoseData: glucoseData)) {
                            TabItem(icon: "chart.bar", label: "Stats")
                        }
                        NavigationLink(destination: HomePageView()) {
                            TabItem(icon: "house.fill", label: "Home", isSelected: true)
                        }
                        NavigationLink(destination: MyInfoPage()) {
                            TabItem(icon: "person.fill", label: "Me")
                        }
                        NavigationLink(destination: HelpPage()) {
                            TabItem(icon: "questionmark.circle", label: "Help")
                        }
                        NavigationLink(destination: QuestionPage()) {
                            TabItem(icon: "doc.text", label: "Questions")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray5))

                    // Blue Section at the Bottom
                    Color("Primary_Color")
                        .frame(height: 40)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
            .ignoresSafeArea(edges: .bottom) // Ensure all content respects safe area
            .navigationBarHidden(true)
        }
    }

    // MARK: - Helper Function to Determine Destination View
    @ViewBuilder
    func destinationView(for mode: String) -> some View {
        switch mode {
        case "Simple":
            SimpleMethodView()
                .navigationBarHidden(true)
        case "Comprehensive":
            ComprehensiveMethodView()
                .navigationBarHidden(true)
        case "Intensive":
            IntensiveView()
                .navigationBarHidden(true)
        default:
            Text("Unknown Mode")
        }
    }

    // MARK: - Helper Function to Format Date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d" // Format for 'December 25'
        return formatter.string(from: date)
    }
}

// MARK: - Metric Card
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
                .foregroundColor(Color("Primary_Color")) // Optional color for values
        }
        .frame(width: 100, height: 80)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

// MARK: - Tab Item
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
    static var previews: some View {
        HomePageView()
    }
}
