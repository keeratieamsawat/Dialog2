import SwiftUI

struct GlucoseStatsView: View {
    
    // vars to store from and to date - create a date range
    @ObservedObject var glucoseData: MyStatisticPage.GlucoseData // Shared data model for glucose statistics
    @State private var fromDate = Date()
    @State private var fromTime = Date()
    @State private var toDate = Date()
    @State private var toTime = Date()
    
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
                let Data: [String: String] = [
                    "fromDate": JSONUtils.combineDateAndTimeAsString(date: fromDate, time: fromTime),
                    "toDate": JSONUtils.combineDateAndTimeAsString(date: fromDate, time: fromTime)
                ]
                do {
                    let jsonData = try JSONUtils.dictionaryToJSONData(Data)
                    // Use jsonData here
                    JSONUtils.sendDataToBackend(jsonData: jsonData, endpoint: "http://127.0.0.1:5000/graphs"){ result in
                        switch result {
                        case .success(let response):
                            // Process the response data
                            DispatchQueue.main.async {
                                glucoseData.data = response.data.map { JSONUtils.convertToDictionary(dataItem: $0) }}
                        case .failure(let error):
                            print("Error fetching data from backend: \(error)")
                        }
                    }
                } catch {
                    print("Error converting dictionary to JSON: \(error.localizedDescription)")
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
                
                GraphView(data: glucoseData.data) // Reuse GraphView
                    .frame(height: 200)
                    .padding()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
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
