import SwiftUI

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
                    HStack(spacing: 5) { // Inner HStack for TextField and Unit
                        TextField("", text: $highBSBolusInsulinDose)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Show numeric keyboard
                            .onChange(of: highBSBolusInsulinDose) { newValue in
                                validateDosage(newValue)
                            }
                            .frame(maxWidth: 100)

                        Text("U") // Units label
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Time Picker
                HStack {
                    Image(systemName: "clock")
                    Text("Time:")
                    Spacer()
                    DatePicker("", selection: $highBSBolusInsulinTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                // Note Input
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $highBSBolusInsulinNote)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.2)))
        .padding(.horizontal)
    }

    // MARK: - Validation Function
    private func validateDosage(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        guard let number = Double(value), number > 0 else {
            errorMessage = "Dosage must be a positive number."
            return
        }

        errorMessage = nil // Clear error if valid
    }
}

struct HighBSInsulinSection_Previews: PreviewProvider {
    static var previews: some View {
        HighBSInsulinSection(
            highBSBolusInsulinDose: .constant(""),
            highBSBolusInsulinTiming: .constant(Date()),
            highBSBolusInsulinNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}

