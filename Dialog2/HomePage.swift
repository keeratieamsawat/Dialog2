import SwiftUI

struct HomePageView: View {
    // Update in real time
    @State private var currentDate = Date()
    
    // Mode selection
    @State private var selectedLogMode: String = "Simple"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Top Section (Date and Log Mode Selection)
                ZStack {
                    Color("Primary_Color")
                        .frame(maxWidth: .infinity, maxHeight: 160)
                        .edgesIgnoringSafeArea(.top)

                    VStack(spacing: 10) {
                        Text(formattedDate(currentDate))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Picker("Log Mode", selection: $selectedLogMode) {
                            Text("Simple").tag("Simple").fontWeight(.bold)
                            Text("Comprehensive").tag("Comprehensive").fontWeight(.bold)
                            Text("Intensive").tag("Intensive").fontWeight(.bold)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                }

                // MARK: - Daily Graph
                VStack {
                    Text("Glucose Trends")
                        .font(.headline)
                        .foregroundColor(.blue)
                    GraphView()
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

                // MARK: - Record Button Navigation (Different Mode)
                NavigationLink(destination: destinationView(for: selectedLogMode)) {
                    Text("RECORD")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 5)
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

    // MARK: - Helper Function to Determine Destination View
    @ViewBuilder
    func destinationView(for mode: String) -> some View {
        switch mode {
        case "Simple":
            SimpleMethodView()
        case "Comprehensive":
            ComprehensiveMethodView()
        //case "Intensive":
            //IntensiveMethodView()
        default:
            Text("Unknown Mode")
        }
    }

    // MARK: - Helper Function to Format Date
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
