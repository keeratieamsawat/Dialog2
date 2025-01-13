// MARK: this is one of the user statistics pages UI, that allows choosing date range. The UI displays a few sample logs with sample data on carbohydrate intake

import SwiftUI

struct CarbIntakeStatView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var time: Date = Date()
    @State private var toDate: Date = Date()
    
    // for carbohydrate intake data
    @State private var carbPortion: String = "350g"
    @State private var carbIntake: String = "1000kCal"
    
    var body: some View {
        VStack(spacing: 0) {
            // top blue header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Carbohydrate Intake")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }

            // date range pickers
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your carbohydrate intake data...")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("From:")
                        DatePicker("", selection: $fromDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("To:")
                        DatePicker("", selection: $toDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
            .padding()

            // carbohydrate intake log
            Text("Carbohydrate Intake Log")
                .font(.headline)
                .foregroundColor(.green)
                .padding(.top)

            // scrollable logs
            ScrollView {
                VStack(spacing: 15) {
                    // some sample logs created with sample data and for loop
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Date:")
                                Spacer()
                                DatePicker("", selection: $fromDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("Time:")
                                Spacer()
                                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Portion Size:")
                                Spacer()
                                Text(carbPortion)
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Carbohydrate Intake:")
                                Spacer()
                                Text(carbIntake)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.2))
                            // each block is rectangle with round edges, and green with an adjusted opacity
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            
            // bottom blue bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y:40)
            }
        }
        .edgesIgnoringSafeArea(.top) // align everything to the top without leaving blank
    }
}

#Preview {
    CarbIntakeStatView()
}

