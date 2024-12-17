import SwiftUI

struct HomePageView: View {
    @State private var selectedLogMode: String = "Simple" // Log mode selection
    @State private var currentDate = Date() // Date Picker

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Top Bar: Date and Log Mode Selection
                VStack {
                    Text(formattedDate(currentDate))
                        .font(.title)
                        .fontWeight(.bold)
                    Picker("Log Mode", selection: $selectedLogMode) {
                        Text("Simple").tag("Simple")
                        Text("Comprehensive").tag("Comprehensive")
                        Text("Intensive").tag("Intensive")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // MARK: - Glucose Graph
                VStack {
                    Text("Glucose Trends")
                        .font(.headline)
                        .foregroundColor(.blue)
                    GraphView() // Placeholder for graph implementation
                        .frame(height: 200)
                        .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                // MARK: - Key Metrics
                HStack {
                    MetricCard(title: "Measured", value: "2 times")
                    MetricCard(title: "Average", value: "4.5 mmol/L")
                    MetricCard(title: "Carb Intake", value: "20 g")
                }
                .padding(.top)

                // MARK: - Record Button
                Button(action: {
                    print("Record button tapped")
                }) {
                    Text("RECORD")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()

                // MARK: - Navigation Tabs
                HStack {
                    TabItem(icon: "chart.bar", label: "Stats")
                    TabItem(icon: "house.fill", label: "Home", isSelected: true)
                    TabItem(icon: "person.fill", label: "Me")
                    TabItem(icon: "questionmark.circle", label: "Help")
                }
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Helper Functions
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d" // Format for 'November 16'
        return formatter.string(from: date)
    }
}

// MARK: - Placeholder for GraphView
struct GraphView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.systemGray4))
            .cornerRadius(8)
            .overlay(Text("Graph Placeholder"))
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

