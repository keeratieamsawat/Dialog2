import SwiftUI

// MARK: - KetoneSection View

// This view allows users to input ketone value, including:
// 1. The level of keton
// 2. The time the keton was measure.
// 3. Optional note about the Note

// The section is designed to be reusable in IntensiveViewMethod
struct KetoneSection: View {
    // Binding properties for ketone value, timing, and note passed from parent view
    @Binding var ketoneValue: String
    @Binding var ketoneTiming: Date
    @Binding var ketoneNote: String

    @State private var errorMessage: String? // State to display error messages related to ketone value validation

    var body: some View {
        VStack(spacing: 10) {
            Text("KETONE")
                .font(.headline)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 10) {
                // Ketone Value Input with Validation
                HStack {
                    Text("VALUE:") // Label for ketone value
                    Spacer()
                    HStack(spacing: 5) {
                        // Input for ketone value
                        TextField("", text: $ketoneValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // Styling for text field
                            .keyboardType(.decimalPad) // Restrict to numeric input
                            .onChange(of: ketoneValue) { newValue,_ in
                                validateKetoneValue(newValue) // Validate value on change
                            }
                            .frame(maxWidth: 100) // Adjust the text field width

                        Text("mmol/L") // Units label for ketone value
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                
                // Display validation error if any
                if let error = errorMessage {
                    Text(error) // Display the error message
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Ketone Timing Picker (for selecting time)
                HStack {
                    Image(systemName: "clock") // Icon for time
                    Text("Time:") // Label
                    Spacer()
                    DatePicker("", selection: $ketoneTiming, displayedComponents: .hourAndMinute) // Date picker for time input
                        .labelsHidden()
                }

                // Ketone Note Input (optional)
                HStack {
                    Image(systemName: "pencil") // Icon for note input
                    Text("Note:") // Label
                    Spacer()
                    TextField("Optional", text: $ketoneNote) // Optional note input field
                        .multilineTextAlignment(.center) // Center alignment for note
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Text field style
                        .frame(maxWidth: 200) // Adjust frame width for note input
                }
            }
        }
        .padding() // Padding around the whole section
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1))) // Background styling with rounded corners
        .padding(.horizontal) // Horizontal padding
    }

    // MARK: - Validation Function
    // This function validates the ketone value input
    private func validateKetoneValue(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        // Check if the ketone value is a valid number between 0.0 and 10.0
        guard let number = Double(value), number >= 0.0, number <= 10.0 else {
            errorMessage = "Value must be a number between 0.0 and 10.0 mmol/L." // Display error if value is invalid
            return
        }

        errorMessage = nil // Clear error if the value is valid
    }
}

// MARK: - Preview for testing the KetoneSection view
struct KetoneSection_Previews: PreviewProvider {
    static var previews: some View {
        KetoneSection(
            ketoneValue: .constant(""),
            ketoneTiming: .constant(Date()),
            ketoneNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}



