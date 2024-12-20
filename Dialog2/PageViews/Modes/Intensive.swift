// Custom DropdownMenu Implementation
import SwiftUI

struct DropdownMenu: View {
    let title: String
    let options: [String]
    @Binding var selection: String?
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            // Main Button to Toggle Dropdown
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection ?? title)
                        .foregroundColor(selection == nil ? .black : .primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .background(RoundedRectangle(cornerRadius: 8))
            }

            // Expanded Options
            if isExpanded {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            if selection == option {
                                // Unselect if already selected
                                selection = nil
                            } else {
                                selection = option
                            }
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(option)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}



struct IntensiveView: View {
    
    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""

    // Carb Bolus Section State
    @State private var CarbBolusDosage: String = ""
    @State private var CarbBolusTiming = Date()
    @State private var CarbBolusNote: String = ""
    
    // High BS Bolus
    @State private var highBSBolusInsulinTiming = Date()
    @State private var highBSBolusInsulinNote: String = ""
    @State private var highBSBolusInsulinDose: String = ""
    
    // Ketone
    @State private var KetoneTiming = Date()
    @State private var KetoneNote: String = ""
    @State private var KetoneValue: String = ""
    

    // Basal rate
    @State private var BasalNote: String = ""
    @State private var BasalValue: String = ""
    @State private var BasalTiming = Date()
    

    // Exercise Section State
    @State private var exerciseName: String = ""
    @State private var duration: String = ""
    @State private var intensity: String = ""
                        
    @State private var selectedIllness: String? = nil
    @State private var selectedStress: String? = nil
    @State private var selectedSkippedMeal: String? = nil
    @State private var selectedMedicationChange: String? = nil
    @State private var selectedTravel: String? = nil
    @State private var unusualEventNote: String = ""

    let illnessOptions = ["Flu", "Fever", "Infection"]
    let stressOptions = ["Work-related stress", "Exam or school stress", "Family/Personal stress"]
    let skippedMealOptions = ["Breakfast", "Lunch", "Dinner"]
    let medicationChangeOptions = ["New medication added", "Missed dose", "Dose adjustment"]
    let travelOptions = ["Long-distance travel", "Time zone change"]
    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .top)

                Text("Intensive Method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .padding(.bottom, 10)
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
                                .foregroundColor(.white)
                        }
                        HStack {
                            Image(systemName: "drop.fill").foregroundColor(.yellow)
                            Text("BLOOD SUGAR LEVEL:").foregroundColor(.white)
                                .lineLimit(1)
                                .layoutPriority(1)
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
                       
                        
                        Text("CARB INSULIN")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                
                                Text("DOSAGE : ")
                                Spacer()
                                TextField("", text: $CarbBolusDosage)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        
                            HStack {
                                Image(systemName: "clock")
                                Text("Time : ")
                                Spacer()
                                DatePicker("", selection: $CarbBolusTiming, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note : ")
                                Spacer()
                                TextField("Optional", text: $CarbBolusNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
                    .padding(.horizontal)
                    
                    // High BS Bolus
                    VStack(spacing: 10) {
                        
                        Text("Hign BS INSULIN")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                
                                Text("DOSAGE : ")
                                Spacer()
                                TextField("", text: $highBSBolusInsulinDose)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        
                            HStack {
                                Image(systemName: "clock")
                                Text("Time : ")
                                Spacer()
                                DatePicker("", selection: $highBSBolusInsulinTiming, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note : ")
                                Spacer()
                                TextField("Optional", text: $highBSBolusInsulinNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.2)))
                    .padding(.horizontal)
                    
                    
                    // Ketones
                    VStack(spacing: 10) {
                        Text("KETONE")
                            .font(.headline)
                            .foregroundColor(.blue)
                        

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                
                                Text("VALUE: ")
                                Spacer()
                                TextField("", text: $KetoneValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        
                            HStack {
                                Image(systemName: "clock")
                                Text("Time : ")
                                Spacer()
                                DatePicker("", selection: $KetoneTiming, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note : ")
                                Spacer()
                                TextField("Optional", text: $KetoneNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 10) {
                        Text("BASAL RATE")
                            .font(.headline)
                            .foregroundColor(.pink)
                        

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                
                                Text("VALUE: ")
                                Spacer()
                                TextField("", text: $BasalValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        
                            HStack {
                                Image(systemName: "clock")
                                Text("Time : ")
                                Spacer()
                                DatePicker("", selection: $BasalTiming, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("Note : ")
                                Spacer()
                                TextField("Optional", text: $BasalNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink.opacity(0.1)))
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
                    
                    VStack(spacing: 20) {
                                            Text("Unusual Event")
                                                .font(.headline)
                                                .padding(.top)
                                                .foregroundColor(.red)

                                            DropdownMenu(title: "Illness", options: illnessOptions, selection: $selectedIllness)
                                            DropdownMenu(title: "Stress", options: stressOptions, selection: $selectedStress)
                                            DropdownMenu(title: "Skipped Meal", options: skippedMealOptions, selection: $selectedSkippedMeal)
                                            DropdownMenu(title: "Medication Changes", options: medicationChangeOptions, selection: $selectedMedicationChange)
                                            DropdownMenu(title: "Travel", options: travelOptions, selection: $selectedTravel)

                                            VStack(alignment: .leading, spacing: 10) {
                                                Text("Other: Please specify")
                                                    .font(.headline)
                                                TextField("Enter your unusual event here", text: $unusualEventNote)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .padding(.horizontal)
                                            }
                                        }
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.1)))
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
        // Collect dropdown values
        let dropdownData: [String: Any?] = [
            "Illness": selectedIllness,
            "Stress": selectedStress,
            "Skipped Meal": selectedSkippedMeal,
            "Medication Changes": selectedMedicationChange,
            "Travel": selectedTravel
        ]
        
        // Collect all data
        var data: [String: Any] = [
            "Date": formattedDate(),
            "Time for blood sugar level": formattedTime(),
            "Blood Sugar Level": bloodSugarLevel,
            "Note": note,
            "Food": food,
            "Portion Size": portionSize,
            "Carbohydrate Intake": carbohydrateIntake,
            
            "Carb bolus dosage": CarbBolusDosage,
            "Carb bolus time": formattedTime(date: CarbBolusTiming),
            "Carb bolus note": CarbBolusNote,
            
            "High BS Bolus dosage": highBSBolusInsulinDose,
            "High BS Bolus Time": formattedTime(date: highBSBolusInsulinTiming),
            "High BS note": highBSBolusInsulinNote,
            
            "Ketone Value": KetoneValue,
            "Ketone Time": formattedTime(date: KetoneTiming),
            "Ketone note": KetoneNote,
            
            "Basal Value": BasalValue,
            "Basal Time": formattedTime(date: BasalTiming),
            "Basal Note": BasalNote,
            
            "Exercise Name": exerciseName,
            "Duration": duration,
            "Intensity": intensity,
            
            "Note in unusual event" : unusualEventNote
        ]
        
        // Merge dropdownData into the main data dictionary
        for (key, value) in dropdownData {
            data[key] = value
        }
        
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

struct Intensive_Previews: PreviewProvider {
    static var previews: some View {
        IntensiveView()
    }
}


