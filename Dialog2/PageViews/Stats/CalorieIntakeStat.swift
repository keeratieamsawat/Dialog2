import SwiftUI

struct CalorieIntakeStatView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var time: Date = Date()
    @State private var toDate: Date = Date()
    
    // for carbohydrate intake data
    @State private var calPortion: String = "500g"
    @State private var calIntake: String = "1500kCal"
    @State private var portionSize: String = "500g"
    @State private var carbohydrateIntake: String = "1500kCal"
    
    var body: some View {
        VStack(spacing: 0) {
            // header
            ZStack {
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Calorie Intake")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }

            // date range pickers
            VStack(alignment: .leading, spacing: 15) {
                Text("Choose a date range to view your calorie intake data...")
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

            // calorie intake log
            Text("Calorie Intake Log")
                .font(.headline)
                .foregroundColor(.green)
                .padding(.top)

            // scrollable logs
            ScrollView {
                VStack(spacing: 15) {
                    // some sample logs
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
                                Text(calPortion)
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Calorie Intake:")
                                Spacer()
                                Text(calIntake)
                                Text("500g")
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Carbohydrate Intake:")
                                Spacer()
                                Text("1500kCal")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.1))
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
    CalorieIntakeStatView()
}
