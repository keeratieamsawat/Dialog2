// Used to store and manage glucose level data
// Sample data used now, need to be fixed to get dynamic data from user input 
import SwiftUI
import Combine

// MARK: - GlucoseData (Shared Data Model)
class GlucoseData: ObservableObject {
    @Published var dailyGlucoseLevels: [CGFloat] = [5.0, 4.8, 5.5, 6.0, 5.2, 4.9]
    
    // Add a new glucose reading
    func addNewReading(_ newValue: CGFloat) {
        dailyGlucoseLevels.append(newValue)
    }
    
    // Calculate the average glucose level
    func calculateAverage() -> Double {
        guard !dailyGlucoseLevels.isEmpty else { return 0.0 }
        let total = dailyGlucoseLevels.reduce(0, +)
        return Double(total) / Double(dailyGlucoseLevels.count)
    }
}

// MARK: - MeasuredStatView
struct MeasuredStatView: View {
    @ObservedObject var glucoseData: GlucoseData

    var body: some View {
        VStack(spacing: 20) {
            Text("Measured Glucose Data")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Total Measurements: \(glucoseData.dailyGlucoseLevels.count) times")
                .font(.headline)
                .padding()

            GraphView(data: glucoseData.dailyGlucoseLevels)
                .frame(height: 300)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            Spacer()
        }
        .navigationTitle("Measured Stats")
        .padding()
    }
}

// MARK: - AverageStatView
struct AverageStatView: View {
    @ObservedObject var glucoseData: GlucoseData

    var body: some View {
        VStack(spacing: 20) {
            Text("Average Glucose Level")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Average: \(String(format: "%.2f", glucoseData.calculateAverage())) mmol/L")
                .font(.headline)
                .padding()

            GraphView(data: glucoseData.dailyGlucoseLevels)
                .frame(height: 300)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            Spacer()
        }
        .navigationTitle("Average Stats")
        .padding()
    }
}

// MARK: - GraphView (Reusable Component)
struct GraphView: View {
    var data: [CGFloat]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard data.count > 1 else { return }
                let width = geometry.size.width
                let height = geometry.size.height
                let stepX = width / CGFloat(data.count - 1)

                path.move(to: CGPoint(x: 0, y: height - data[0] * height / 7))
                for index in 1..<data.count {
                    let x = stepX * CGFloat(index)
                    let y = height - data[index] * height / 7
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

