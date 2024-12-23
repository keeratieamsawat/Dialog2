import SwiftUI

struct InsulinStatView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var time: Date = Date()
    @State private var toDate: Date = Date()
    
    // for insulin intake data
    @State private var medicationName: String = "medication"
    @State private var dosage: String = "dose"
    @State private var insulinTiming = Date()
    @State private var insulinNote: String = "insulin taken on time"

    
    var body: some View {
        VStack(spacing: 0) {
            // header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Insulin Intake")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }

            // date range pickers
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your insulin intake data...")
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

            // insulin intake log
            Text("Insulin Intake Log")
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.top)

            // scrollable logs
            ScrollView {
                VStack(spacing: 15) {
                    // some sample logs
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "pills")
                                Text("Medication: ")
                                Spacer()
                                Text("\(medicationName)")
                            }
                            HStack {
                                Image(systemName: "drop")
                                Text("Dosage: ")
                                Spacer()
                                Text("\(dosage)")
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("Time: ")
                                Spacer()
                                DatePicker("",selection:$insulinTiming,displayedComponents:.hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note: ")
                                Spacer()
                                Text("\(insulinNote)")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange.opacity(0.1))
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
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    InsulinStatView()
}
