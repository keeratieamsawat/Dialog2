
import SwiftUI

struct ComprehensiveMethodView: View {
    
    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @State private var bloodSugarLevel: String = ""
    @State private var note: String = ""
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""

    // New Insulin Section State
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var insulinTiming = Date()
    @State private var insulinNote: String = ""
    
    @State private var exerciseName: String = ""
    @State private var duration: String = ""
    @State private var intensity: String = ""


    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .top)

                Text("Comprehensive Method")
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
                        }
                        HStack{
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
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                Spacer()
                                TextField("", text: $carbohydrateIntake)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            HStack {
                                Image(systemName: "pencil")
                                Text("NOTE:")
                                Spacer()
                                TextField("Optional", text: $note)
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
                        // Wrap the title and the content inside the same orange background
                        VStack(spacing: 10) {
                            Text("INSULIN")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity, alignment: .center) // Center-align the header

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
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1))) // Orange Box
                    }
                    .padding(.horizontal)
                    
                    
                    // Exercise Section
                    VStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            // Exercise Title - Inside Purple Box
                            Text("EXERCISE")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Name Input
                            HStack {
                                Text("Type of Exercise :")
                                Spacer()
                                TextField("", text: $exerciseName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            }
                            
                            // Duration Picker
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.purple)
                                Text("Duration :")
                                    //.fontWeight(.semibold)
                                Spacer()
                                Picker("Pick an option", selection: $duration) {
                                    Text("1 Min - 15 Min").tag("1 Min - 15 Min")
                                    Text("16 Min - 30 Min").tag("16 Min - 30 Min")
                                    Text("31 Min - 45 Min").tag("31 Min - 45 Min")
                                    Text("46 Min - 1 Hour").tag("46 Min - 1 Hour")
                                    Text("More than 1 Hour").tag("More than 1 Hour")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: 200)
                            }
                            
                            // Intensity Picker - Centered
                            VStack {
                                Text("Intensity")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity, alignment: .center) // Centering Title
                                
                                // Buttons Centered
                                HStack(spacing: 20) {
                                    Spacer()
                                    Button(action: { intensity = "Low" }) {
                                        intensityButton(icon: "waveform.path.ecg", title: "Low", isSelected: intensity == "Low")
                                    }
                                    Button(action: { intensity = "Medium" }) {
                                        intensityButton(icon: "waveform.path.ecg", title: "Medium", isSelected: intensity == "Medium")
                                    }
                                    Button(action: { intensity = "High" }) {
                                        intensityButton(icon: "waveform.path.ecg", title: "High", isSelected: intensity == "High")
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 1)) // Purple Box
                    }
                    .padding(.horizontal)

                    // Apply Button
                    Button(action: {
                        print("Date: \(formattedDate())")
                        print("Time: \(formattedTime())")
                    }) {
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
    
    @ViewBuilder
    private func intensityButton(icon: String, title: String, isSelected: Bool) -> some View {
        HStack {
            //Image(systemName: icon)
                //.foregroundColor(isSelected ? .white : .purple)
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .purple)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(isSelected ? Color.purple : Color.clear)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.purple, lineWidth: 1))
    }


    // Helper to format Date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }

    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }

    // Reusable Section Row
    private func sectionRow<Content: View>(icon: String, title: String, color: Color = .green, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(color)
            Text(title).fontWeight(.semibold)
            Spacer()
            content()
        }
    }
}

struct ComprehensiveMethodView_Previews: PreviewProvider {
    static var previews: some View {
        ComprehensiveMethodView()
    }
}
