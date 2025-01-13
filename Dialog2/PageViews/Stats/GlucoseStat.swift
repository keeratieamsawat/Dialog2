// Shared glucose data model
import SwiftUI

// MARK: - GlucoseStatView
struct GlucoseStatView: View {
    
    // ObservedObject wrapper allows the view page to observe and display changes glucoseData
    @ObservedObject var glucoseDataDefault: MyStatisticPage.GlucoseData

    var body: some View {
        VStack(spacing: 20) {
            Text("Glucose Statistics")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Glucose Trend")
                .font(.headline)
                .foregroundColor(.blue)

            // Create a list of data points for the graph (x-axis: date, y-axis: glucose value)
//            let graphData: [[String: Any]] = glucoseData.data.compactMap { item -> [String: Any]? in
//                if let date = JSONUtils.convertStringToDate(dateString: item["date"] as? String ?? ""),
//                   let value = item["value"] as? Double {
//                    return ["date": date, "value": value]
//                }
//                return nil
//            }

            GraphView(data: glucoseDataDefault.data)
                .frame(height: 200)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            Text("Glucose Measurements")
                .font(.headline)
                .padding(.top)

            List {
                ForEach(glucoseDataDefault.data.indices, id: \.self) { index in
                    Text("Reading \(index + 1): \(String(format: "%.2f", glucoseDataDefault.data[index]["value"] as? Double ?? 0)) mmol/L")
                        .padding(5)
                }
            }
            .frame(maxHeight: 300)

            Spacer()
        }
        .padding()
        .navigationTitle("Glucose Statistics")
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}


//struct GlucoseStatView_Previews: PreviewProvider {
//    static var glucoseData = MyStatisticPage.GlucoseData() // Initialize with some mock data
//    static var previews: some View {
//        GlucoseStatView(glucoseDataDefault: glucoseDataDefault)
//    }
//}
