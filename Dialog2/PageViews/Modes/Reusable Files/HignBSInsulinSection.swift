import SwiftUI

// This view allows users to input high bs insulin details, including:
// 1. The dosage of high bs insulin (U)
// 2. The time the highbs insulin was taken
// 3. Optional note about the Note
// The section is designed to be reusable across in IntensiveViewMethod


struct HighBSInsulinSection: View {
    @Binding var highBSBolusInsulinDose: String
    @Binding var highBSBolusInsulinTiming: Date
    @Binding var highBSBolusInsulinNote: String

    @State private var errorMessage: String? // For dosage validation errors

    var body: some View {
        VStack(spacing: 10) {
            Text("HIGH BS INSULIN")
                .font(.headline)
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 10) {
                
                // Dosage Input with Validation
                HStack {
                    Text("DOSAGE (Units):")
                    Spacer()
                    HStack(spacing: 5) { // Inner HStack for TextField and Unit label
                        TextField("", text: $highBSBolusInsulinDose) // Insulin dose input field
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Numeric keyboard for dosage input
                            .onChange(of: highBSBolusInsulinDose) { newValue,_ in
                                validateDosage(newValue) // Validate when input changes
                            }
                            .frame(maxWidth: 100) // Limit width

                        Text("U") // Label for insulin units
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }

                // Display validation error if input is invalid
                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Time Picker for insulin administration time
                HStack {
                    Image(systemName: "clock") // Icon for time
                    Text("Time:")
                    Spacer()
                    DatePicker("", selection: $highBSBolusInsulinTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden() // Hides labels for a cleaner look
                }

                // Optional note input
                HStack {
                    Image(systemName: "pencil") // Icon for notes
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $highBSBolusInsulinNote) // Note input field
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding() // Padding around the section
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.2))) // Background with rounded corners and light color
        .padding(.horizontal) // Horizontal padding
    }

    // MARK: - Validation Function for Insulin Dosage
    private func validateDosage(_ value: String) {
        // Ensure the dosage is a positive number
        guard !value.isEmpty else {
            errorMessage = nil // No error if the field is left blank
            return
        }

        guard let number = Double(value), number > 0 else {
            errorMessage = "Dosage must be a positive number." // Error if invalid
            return
        }

        errorMessage = nil // Clear error if valid
    }
}


// MARK: - Preview HignBSInsulin section
struct HighBSInsulinSection_Previews: PreviewProvider {
    static var previews: some View {
        // Preview the section with sample data
        HighBSInsulinSection(
            highBSBolusInsulinDose: .constant(""),
            highBSBolusInsulinTiming: .constant(Date()),
            highBSBolusInsulinNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}

