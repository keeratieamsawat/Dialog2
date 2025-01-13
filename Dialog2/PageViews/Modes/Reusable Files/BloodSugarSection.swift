import SwiftUI

// BloodSugarSection is a view that handles the input of blood sugar-related data, including:
// 1. Date and time of the measurement
// 2. Blood sugar level (in mmol/L)
// 3. The condition (pre-meal or post-meal)
// 4. An optional note for additional details
//
// This section is designed to be reused across different views (Simple method,Comprehensive method and Intensive Method ).

    // MARK: - UI of blood sugar section.
struct BloodSugarSection: View {
    
    // Binding variables input from SimpleMethodView,ComprehensiveMethodView and IntensiveMethodView
    @Binding var selectedDate: Date  // The selected date
    @Binding var bloodSugarTime: Date  // The time of blood sugar measurement
    @Binding var bloodSugarLevel: String  // The blood sugar level input by the user
    @Binding var mealTiming: String  // The condition (Pre-meal/Post-meal)
    @Binding var noteBloodSugar: String  // Additional notes related to the blood sugar measurement
    
    @State var validationError: String? // State to hold validation error messages (if any)

    var body: some View {
        
        VStack(spacing: 15) {
            // Date Picker for selecting the date of the blood sugar measurement
            HStack {
                Image(systemName: "calendar").foregroundColor(.white)
                Text("DATE:").foregroundColor(.white)
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .foregroundColor(.white)
            }

            // Blood Sugar Time Picker for selecting the time when the blood sugar level is measured
            HStack {
                Image(systemName: "clock").foregroundColor(.white)
                Text("BLOOD SUGAR TIME:")
                    .foregroundColor(.white)
                    .lineLimit(1) // Limit the text to a single line
                    .layoutPriority(1)
                Spacer()
                DatePicker("", selection: $bloodSugarTime, displayedComponents: .hourAndMinute)
                    .foregroundColor(.white)
            }

            // Input for the blood sugar level with validation
            HStack {
                Image(systemName: "drop.fill").foregroundColor(.yellow)
                Text("BLOOD SUGAR LEVEL:").foregroundColor(.white)
                    .lineLimit(1)
                    .layoutPriority(1)
                Spacer()
                TextField("", text: $bloodSugarLevel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad) // Set the numeric keypad for input
                    .onChange(of: bloodSugarLevel) { newValue, _ in
                        validateBloodSugarLevel(newValue)  // Validate blood sugar level on change
                    }
                Text("mmol/L").foregroundColor(.black).font(.footnote)  // Display units
            }

            // Display validation error if any
            if let errorMessage = validationError {
                Text(errorMessage).font(.caption).foregroundColor(.red).padding(.top, -10)
            }
            
            // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com

            // Picker for selecting meal timing (Pre-meal or Post-meal)
            HStack {
                Image(systemName: "pencil").foregroundColor(.white)
                Text("CONDITION:").foregroundColor(.white)
                Spacer()
                Picker("", selection: $mealTiming) {
                    Text("Pre-meal").tag("Pre-meal")
                    Text("Post-meal").tag("Post-meal")
                }
                .pickerStyle(SegmentedPickerStyle())  // Use a segmented picker for better UI
                .frame(maxWidth: 200)  // Set the maximum width
            }
            
            // End of reference 1

            // Notes field for optional notes related to blood sugar measurement
            HStack {
                Text("NOTE:").foregroundColor(.white)
                Spacer()
                TextField("Optional", text: $noteBloodSugar)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
            }
        }
        .padding()  // Add padding inside the section
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))  // Background styling
        .padding(.horizontal)  // Horizontal padding for spacing
    }
    
    // MARK: - Validation Function for Blood Sugar Level
    private func validateBloodSugarLevel(_ value: String) {
        // Check if the value is empty or not
        if value.isEmpty {
            validationError = nil  // No error if the input is empty
        } else if let bloodSugar = Double(value) {
            // Validate the blood sugar level (within a reasonable range)
            if bloodSugar < 0 {
                validationError = "Blood sugar level cannot be negative."
            } else if bloodSugar > 50 {
                validationError = "Blood sugar level seems too high. Please check your input."
            } else {
                validationError = nil  // Clear error if valid
            }
        } else {
            // Error if the value is not a valid number
            validationError = "Please enter a valid numeric value."
        }
    }
}

// MARK: - Preview for BloodSugarSection

// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
struct BloodSugarSection_Previews: PreviewProvider {
    static var previews: some View {
        BloodSugarSection(
            selectedDate: .constant(Date()),
            bloodSugarTime: .constant(Date()),
            bloodSugarLevel: .constant(""),
            mealTiming: .constant("Pre-meal"),
            noteBloodSugar: .constant("")
        )
    }
}
// End of reference 1


