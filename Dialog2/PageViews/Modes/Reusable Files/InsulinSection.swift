import SwiftUI

// MARK: - InsulinSection View
// This view allows users to input insulin details, including:
// 1. The name of insulin medicine
// 2. The time the insulin was taken
// 3. The dosage of insulin user has taken
// 4. Optional note about the Note

// The section is designed to be reusable in SimpleMethodview and ComprehensiveMethodView


struct InsulinSection: View {
    // Binding variables for input fields passed from parent view
    @Binding var medicationName: String
    @Binding var insulinTiming: Date
    @Binding var dosage: String
    @Binding var insulinNote: String

    @State private var dosageErrorMessage: String? // For dosage validation errors

    var body: some View {
        VStack(spacing: 10) {
            Text("INSULIN")
                .font(.headline)
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 10) {
                // Medication Name Input Field
                HStack {
                    Image(systemName: "pills") // Icon for medication
                    Text("Medication:") // Label
                    Spacer()
                    TextField("", text: $medicationName) // Text field for medication name
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Timing Picker (for insulin timing)
                HStack {
                    Image(systemName: "clock") // Icon for time picker
                    Text("Timing:") // Label
                    Spacer()
                    DatePicker("", selection: $insulinTiming, displayedComponents: .hourAndMinute) // Time picker for insulin timing
                        .labelsHidden()
                }

                // Dosage Input with Validation
                HStack {
                    Image(systemName: "drop") // Icon for dosage
                    Text("Dosage (Units):") // Label
                    Spacer()
                    HStack(spacing: 5) {
                        TextField("", text: $dosage) // Input field for dosage
                            .keyboardType(.decimalPad) // Restrict to numeric input
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: dosage) { newValue,_ in
                                validateDosage(newValue) // Validate dosage on change
                            }
                            .frame(maxWidth: 100)

                        Text("U") // Unit label for dosage
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }

                // Show error message if dosage validation fails
                if let error = dosageErrorMessage {
                    Text(error) // Display error
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Note Input for optional note
                HStack {
                    Image(systemName: "pencil") // Icon for note input
                    Text("Note:") // Label
                    Spacer()
                    TextField("Optional", text: $insulinNote) // Text field for note
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1))) // Background styling
        .padding(.horizontal)
    }

    // MARK: - Validation Functions
    // This function validates the dosage to ensure it's a positive number
    private func validateDosage(_ value: String) {
        guard !value.isEmpty else {
            dosageErrorMessage = nil // No error if left blank
            return
        }

        guard let number = Double(value), number > 0 else {
            dosageErrorMessage = "Dosage must be a positive number." // Error message if invalid
            return
        }

        dosageErrorMessage = nil // Clear error if valid
    }
}

// MARK: - Preview of insulin section

struct InsulinSection_Previews: PreviewProvider {
    @State static var medicationName = ""
    @State static var dosage = ""
    @State static var insulinTiming = Date()
    @State static var insulinNote = ""

    static var previews: some View {
        InsulinSection(
            medicationName: $medicationName,
            insulinTiming: $insulinTiming,
            dosage: $dosage,
            insulinNote: $insulinNote
        )
    }
}



