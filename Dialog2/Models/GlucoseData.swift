// Used to store and manage glucose level data
// Sample data used now, need to be fixed to get dynamic data from user input
import SwiftUI
import Combine


// MARK: - MeasuredStatView
struct MeasuredStatView: View {
    @ObservedObject var glucoseData: MyStatisticPage.GlucoseData

    var graphLineColor: Color = Color("Primary_Color")

    var body: some View {
        VStack(spacing: 20) {
            Text("Measured Glucose Data")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Total Measurements: \(glucoseData.data.count) times")
                .font(.headline)
                .foregroundColor(Color("Primary_Color"))
                .padding()

            GraphView(data: glucoseData.data)
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

struct AverageStatView: View {
    @ObservedObject var glucoseData: MyStatisticPage.GlucoseData

    var body: some View {
        VStack(spacing: 20) {
            Text("Average Glucose Level")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Average: \(String(format: "%.2f", glucoseData.calculateAverage())) mmol/L")
                .font(.headline)
                .padding()

            GraphView(data: glucoseData.data)
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
    var data: [[String: Any]]

    // Helper function to convert date string to Date
    func convertToDate(dateStr: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: dateStr)
    }
    
    func calculateAdjustedYRange(minY: CGFloat, maxY: CGFloat) -> (CGFloat, CGFloat) {
        if maxY == minY {
            let padding: CGFloat = 5.0
            return (minY - padding, maxY + padding)
        } else {
            let padding = (maxY - minY) * 0.1
            return (minY - padding, maxY + padding)
        }
    }


    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            // Padding for axis labels and values
            let padding: CGFloat = 40

            // Convert data into usable points
            let points = data.compactMap { item -> (CGFloat, CGFloat)? in
                guard
                    let dateStr = item["date"] as? String,
                    let value = item["value"] as? Double,
                    let date = convertToDate(dateStr: dateStr) // Using the helper function
                else {
                    return nil
                }
                return (CGFloat(date.timeIntervalSince1970), CGFloat(truncating: value as NSNumber))
            }

            // If no points are available, show a message
            if points.isEmpty {
                Text("No data available")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
                    .font(.headline)
            } else {
                // Extract x and y values
                let xValues = points.map { $0.0 }
                let yValues = points.map { $0.1 }

                // Ensure min and max values exist for scaling
                if let minY = yValues.min(), let maxY = yValues.max() {
                    // Add padding to Y-axis range
                    let (adjustedMinY, adjustedMaxY) = calculateAdjustedYRange(minY: minY, maxY: maxY)

                    let xSpacing = (width - padding * 2) / CGFloat(points.count - 1)
                    let yScale = (height - padding * 2) / (adjustedMaxY - adjustedMinY)

                    ZStack {
                        // Draw axes
                        Path { path in
                            // Y-axis
                            path.move(to: CGPoint(x: padding, y: padding))
                            path.addLine(to: CGPoint(x: padding, y: height - padding))
                            // X-axis
                            path.move(to: CGPoint(x: padding, y: height - padding))
                            path.addLine(to: CGPoint(x: width - padding, y: height - padding))
                        }
                        .stroke(Color.gray, lineWidth: 1)

                        // Add grid lines for better readability
                        ForEach(0..<5) { index in
                            let yPosition = height - padding - (CGFloat(index) / 4 * (height - padding * 2))
                            let xPosition = padding + CGFloat(index) * xSpacing

                            // Horizontal grid line
                            Path { path in
                                path.move(to: CGPoint(x: padding, y: yPosition))
                                path.addLine(to: CGPoint(x: width - padding, y: yPosition))
                            }
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)

                            // Vertical grid line
                            Path { path in
                                path.move(to: CGPoint(x: xPosition, y: padding))
                                path.addLine(to: CGPoint(x: xPosition, y: height - padding))
                            }
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        

                        // Draw the graph line
                        Path { path in
                            for (index, point) in points.enumerated() {
                                let xPosition = padding + CGFloat(index) * xSpacing
                                let yPosition = height - padding - (point.1 - adjustedMinY) * yScale

                                if index == 0 {
                                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                                } else {
                                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                                }
                            }
                        }
                        .stroke(Color.blue, lineWidth: 2)
                        
                        // Add X-axis values for each point
//                        ForEach(Array(points.enumerated()), id: \.offset) { index, point in
//                            let xPosition = padding + CGFloat(index) * xSpacing
//                            let date = Date(timeIntervalSince1970: TimeInterval(point.0))
//                            Text(date.formatted(date: .abbreviated, time: .shortened))
//                                .font(.caption2)
//                                .foregroundColor(.gray)
//                                .rotationEffect(.degrees(-45))
//                                .frame(width: 50, alignment: .center)
//                                .position(x: xPosition, y: height - padding + 20)
//                        }

                        // Add Y-axis values for each grid line
                        ForEach(0..<5) { index in
                            let yValue = adjustedMinY + CGFloat(index) / 4 * (adjustedMaxY - adjustedMinY)
                            let yPosition = height - padding - (CGFloat(index) / 4 * (height - padding * 2))
                            Text(String(format: "%.1f", yValue))
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing)
                                .position(x: padding - 20, y: yPosition)
                        }

                       // Add X-axis label
                       Text("Log Date and Time")
                           .font(.caption)
                           .foregroundColor(.gray)
                           .position(x: width / 2, y: height - 10)

                       // Add Y-axis label
                       Text("Blood Glucose Levels (mmol/L)")
                           .font(.caption)
                           .foregroundColor(.gray)
                           .rotationEffect(.degrees(-90))
                           .position(x: 10, y: height / 2)
                   }
                    
                } else {
                    // If data is invalid, show a message
                    Text("Invalid data")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.red)
                        .font(.headline)
                }
            }
        }
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}
