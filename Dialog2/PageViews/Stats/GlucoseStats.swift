import SwiftUI

struct GlucoseStatsView: View {
    
    // vars to store from and to date - create a date range
    @StateObject var glucoseData: MyStatisticPage.GlucoseData = MyStatisticPage.GlucoseData() // Shared data model for glucose statistics
    @State private var fromDate = Date()
    @State private var fromTime = Date()
    @State private var toDate = Date()
    @State private var toTime = Date()
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
        
        VStack(spacing: 0) {
            // header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Blood Sugar Statistics")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }
            
            // MARK: date range pickers
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your blood sugar data...")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("From:")
                        DatePicker("", selection: $fromDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())

                        DatePicker("", selection: $fromTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("To:")
                        DatePicker("", selection: $toDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())

                        DatePicker("", selection: $toTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
            .padding()
            .onTapGesture {
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
                        } else {
                            print("Failed to fetch data.")
                        }
                    }
                }
                
                // MARK: - Glucose Trend Graph
//                let graphData: [[String: Any]] = glucoseData.data.compactMap { item -> [String: Any]? in
//                    if let date = JSONUtils.convertStringToDate(dateString: item["date"] as? String ?? ""),
//                       let value = item["value"] as? Double {
//                        return ["date": date, "value": value]
//                    }
//                    return nil
//                }
                
                Text("Glucose Trend")
                    .font(.headline)
                    .foregroundColor(.blue)
                if glucoseData.data.isEmpty {
                    Text("No data available")
                        .frame(width: 350, height: 300)
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    // Render GraphView only when data is available
                    GraphView(data: glucoseData.data)
                        .frame(height: 300)
                        .padding()
                }
                
                // MARK: - Measurements List
                Text("Glucose Measurements")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top)
                
                List {
                    ForEach(glucoseData.data.indices, id: \.self) { index in
                        Text("Reading \(index + 1): \(String(format: "%.2f", glucoseData.data[index]["value"] as? Double ?? 0)) mmol/L")
                            .padding(5)
                    }
                }            .padding()
                
                // MARK: bottom blue bar
                ZStack {
                    Color("Primary_Color")
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.bottom)
                        .offset(y:40)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    
}
