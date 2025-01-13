import SwiftUI

// MARK: - CarbInsulinSection View
// This view allows users to input carb insulin details, including:
// 1. Dose of carb insulin
// 2. Timing of carb insulin taken
// 3. Note
// The section is used in IntensiveViewMethod.

struct CarbInsulinSection: View {
    
    // The @Binding properties are used to pass data from the IntensiveViewMethod view and allow for changes.
    @Binding var carbBolusDosage: String   // Carb dosage input
    @Binding var carbBolusTiming: Date     // Carb bolus timing input
    @Binding var carbBolusNote: String     // Optional note related to carb bolus
    
    @State private var errorMessage: String? // For error message display

    var body: some View {
        VStack(spacing: 10) {
            // Section Title
            Text("CARB INSULIN") // Title of the section
                .font(.headline)
                .foregroundColor(.orange)

            // VStack to arrange input fields for carb bolus dosage, timing, and note
            VStack(alignment: .leading, spacing: 10) {
                
                // Dosage Input Field with Validation
                HStack {
                    Text("DOSE (Units):")  // Label for dosage input
                    Spacer()
                    HStack {
                        // TextField for entering the carb bolus dosage
                        TextField("", text: $carbBolusDosage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .onChange(of: carbBolusDosage) { newValue, _ in
                                validateCarbBolusDosage(newValue) // Validate input whenever it changes
                            }
                            .frame(maxWidth: 100)
                        
                        Text("U") // Units label for dosage (U = Units)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }

                // Display validation error if present
                if let error = errorMessage {
                    Text(error)  // Display the error message
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)  
                }

                // Timing Picker (for when the bolus is administered)
                HStack {
                    Image(systemName: "clock")
                    Text("Timing:")
                    Spacer()
                    DatePicker("", selection: $carbBolusTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                // Optional Notes Input Field
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    // TextField for entering notes related to the bolus
                    TextField("Optional", text: $carbBolusNote)
                        .multilineTextAlignment(.center) // Center the text in the input field
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))  // Background with rounded corners and orange color with opacity
        .padding(.horizontal)
    }

    // MARK: - Validation Function for Carb Bolus Dosage
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    // This function validates the carb bolus dosage to ensure it's within a valid range.
    private func validateCarbBolusDosage(_ value: String) {
        // If the value is empty, no error is displayed
        guard !value.isEmpty else {
            errorMessage = nil
            return
        }

        // Check if the input is a valid number within a valid range (0.1 to 50)
        guard let number = Double(value), number > 0, number <= 50 else {
            errorMessage = "Invalid Input"  // Error message if input is invalid
            return
        }

        // Clear error if the input is valid
        errorMessage = nil
    }
}
    // end of reference 1

// MARK: - Preview for CarbInsulinSection
// A preview for the CarbInsulinSection to display the UI in the canvas.

struct CarbInsulinSection_Previews: PreviewProvider {
    static var previews: some View {
        // Preview the view with initial values for carb bolus dosage, timing, and notes
        CarbInsulinSection(
            carbBolusDosage: .constant(""),
            carbBolusTiming: .constant(Date()),
            carbBolusNote: .constant("")
        )
        .previewLayout(.sizeThatFits)  // Set the preview layout
    }
}


