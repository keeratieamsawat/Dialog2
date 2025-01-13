// MARK: this is one of the user statistics pages UI, that allows choosing date range. The UI displays a few sample logs with sample data on calorie intake
// similar style of pages are used in other statistics pages UI, thus comments in this page goes the same for other pages under the Stats folder

import SwiftUI

struct CalorieIntakeStatView: View {
    
    // vars to store from and to date - create a date range
    @State private var fromDate: Date = Date()
    @State private var time: Date = Date()
    @State private var toDate: Date = Date()
    
    // for carbohydrate intake data: some sample data for displaying on UI
    @State private var calPortion: String = "500g"
    @State private var calIntake: String = "1500kCal"
    @State private var portionSize: String = "500g"
    @State private var carbohydrateIntake: String = "1500kCal"
    
    var body: some View {
        VStack(spacing: 0) {
            // blue background header on top of page
            ZStack {
            // ZStack is the "depth" aligner (z-axis), making text displaying onto the blue background
                Color("Primary_Color")
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .edgesIgnoringSafeArea(.top)
                Text("Calorie Intake")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(y:20)
            }

            // two separate date pickers to allow using to choose a date range
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

            // calorie intake log text
            Text("Calorie Intake Log")
                .font(.headline)
                .foregroundColor(.green)
                .padding(.top)

            // using ScrollView to achieve scrollable UI (on Xcode preview page need to click and scroll)
            ScrollView {
                VStack(spacing: 15) {
                    // using for loop to make a few sample logs
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 10) {
                        // using VStack to vertically align the blocks
                            HStack {
                            // using HStack to align components horizontally
                                Image(systemName: "calendar")
                                // these images are built-in icons in Xcode for use
                                Text("Date:")
                                Spacer()
                                DatePicker("", selection: $fromDate, displayedComponents: .date)
                                // for choosing date, make date picker displays in the style of date
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("Time:")
                                Spacer()
                                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                // for time, make date picker display in the style of hour and minute
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
                            // make each block appear to be green rectangles with round corners, and adjust opacity
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
        .edgesIgnoringSafeArea(.top) // make all components align to the top, leaving no blanks at the top
    }
}

#Preview {
    CalorieIntakeStatView()
}
