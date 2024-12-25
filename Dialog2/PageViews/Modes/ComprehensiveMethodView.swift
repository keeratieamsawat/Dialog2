
import SwiftUI

struct ComprehensiveMethodView: View {
    
    @Environment(\.presentationMode) var presentationMode // For home page navigation
    
    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""

    // Insulin Section State
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var insulinTiming = Date()
    @State private var insulinNote: String = ""

    // Exercise Section State
    @State private var exerciseName: String = ""
    @State private var duration: String = ""
    @State private var intensity: String = ""

    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                            Color("Primary_Color")
                                .frame(height: 120)
                                .edgesIgnoringSafeArea(.top)

                HStack {
                                   // Close Icon on the Left
                                   Button(action: {
                                       presentationMode.wrappedValue.dismiss() // Close the page
                                   }) {
                                       Image(systemName: "xmark")
                                           .font(.title2)
                                           .foregroundColor(.white)
                                   }
                                   .frame(width: 50) // Ensure consistent spacing

                                   Spacer() // Ensures title is centered

                                   // Title in the Middle
                                   Text("Comprehensive Method")
                                       .font(.title2)
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                                       .frame(maxWidth: .infinity, alignment: .center)

                                   Spacer() // Ensures title is centered

                                   // Invisible Button to Balance Layout
                                   Button(action: {}) {} // Placeholder for symmetry
                                       .frame(width: 50) // Same width as the close button
                               }
                               .padding(.horizontal, 13)
                               .padding(.top, 40)
                               .frame(height: 120)
                               
                           }

            // Scrollable Content
            ScrollView {
                VStack(spacing: 15) {
                    // Main Content
                    Text("Ideal refining lifestyle or treatment strategies to improve diabetes management")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Blue Section for Date, Time, and Blood Sugar
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "calendar").foregroundColor(.white)
                            Text("DATE:").foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        HStack {
                            Image(systemName: "clock").foregroundColor(.white)
                            Text("TIME:").foregroundColor(.white)
                            Spacer()
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        HStack {
                            Image(systemName: "drop.fill").foregroundColor(.yellow)
                            Text("BLOOD SUGAR LEVEL:").foregroundColor(.white)
                            Spacer()
                            TextField("", text: $bloodSugarLevel)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 150)
                        }
                        HStack {
                            Image(systemName: "pencil").foregroundColor(.white)
                            Text("NOTE:").foregroundColor(.white)
                            Spacer()
                            TextField("Optional", text: $note)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))
                    .padding(.horizontal)

                    // Food Section
                    VStack(spacing: 10) {
                        Text("FOOD")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        HStack(spacing: 10) {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab)
                                    .fontWeight(.semibold) // Optional: to emphasize the tab text
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .lineLimit(1) // Ensures text is on one line
                                    .minimumScaleFactor(0.5) // Shrinks text to fit if needed
                                    .background(selectedTab == tab ? Color.green : Color.clear)
                                    .foregroundColor(selectedTab == tab ? .white : .green)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                                    .frame(minWidth: 0, maxWidth: .infinity) // Makes tabs equal width
                                    .onTapGesture {
                                        selectedTab = tab
                                    }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Time:")
                                Spacer()
                                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Food:")
                                Spacer()
                                TextField("", text: $food)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "chart.bar")
                                Text("Portion Size:")
                                Spacer()
                                TextField("", text: $portionSize)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Text("Carbohydrate Intake:")
                                Spacer()
                                TextField("", text: $carbohydrateIntake)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
                    .padding(.horizontal)

                    // Insulin Section
                    VStack(spacing: 10) {
                        Text("INSULIN")
                            .font(.headline)
                            .foregroundColor(.orange)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "pills")
                                Text("Medication : ")
                                Spacer()
                                TextField("", text: $medicationName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "drop")
                                Text("Dosage : ")
                                Spacer()
                                TextField("", text: $dosage)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("Timing : ")
                                Spacer()
                                DatePicker("", selection: $insulinTiming, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note : ")
                                Spacer()
                                TextField("Optional", text: $insulinNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
                    .padding(.horizontal)

                    // Exercise Section
                    VStack(spacing: 10) {
                        Text("EXERCISE")
                            .font(.headline)
                            .foregroundColor(.purple)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Type of Exercise :")
                                Spacer()
                                TextField("", text: $exerciseName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "hourglass")
                                Text("Duration :")
                                Spacer()
                                TextField("", text: $duration)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Text("Intensity")
                                Spacer()
                                TextField("", text: $intensity)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple.opacity(0.1)))
                    .padding(.horizontal)

                    // Apply Button
                    Button(action: saveData) {
                        Text("APPLY")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary_Color"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .edgesIgnoringSafeArea([.leading, .trailing])

            // Bottom Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func saveData() {
        // Collect all data
        let data: [String: Any] = [
            "Date": formattedDate(),
            "Time": formattedTime(),
            "Blood Sugar Level": bloodSugarLevel,
            "Note": note,
            "Food": food,
            "Portion Size": portionSize,
            "Carbohydrate Intake": carbohydrateIntake,
            "Medication Name": medicationName,
            "Dosage": dosage,
            "Insulin Timing": formattedTime(date: insulinTiming),
            "Insulin Note": insulinNote,
            "Exercise Name": exerciseName,
            "Duration": duration,
            "Intensity": intensity
        ]

        // Print data to debug
        print("Saved Data:", data)
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }

    private func formattedTime(date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ComprehensiveMethodView_Previews: PreviewProvider {
    static var previews: some View {
        ComprehensiveMethodView()
    }
}
