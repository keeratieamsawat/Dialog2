import SwiftUI

struct InsulinSection: View {
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
                // Medication Name Input
                HStack {
                    Image(systemName: "pills")
                    Text("Medication:")
                    Spacer()
                    TextField("", text: $medicationName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Timing Picker
                HStack {
                    Image(systemName: "clock")
                    Text("Timing:")
                    Spacer()
                    DatePicker("", selection: $insulinTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                // Dosage Input with Validation
                HStack {
                    Image(systemName: "drop")
                    Text("Dosage (Units):")
                    Spacer()
                    HStack(spacing: 5) {
                        TextField("", text: $dosage)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: dosage) { newValue in
                                validateDosage(newValue)
                            }
                            .frame(maxWidth: 100)

                        Text("U") // Units label
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                if let error = dosageErrorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Note Input
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $insulinNote)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
        .padding(.horizontal)
    }

    // MARK: - Validation Functions
    private func validateDosage(_ value: String) {
        guard !value.isEmpty else {
            dosageErrorMessage = nil // No error if left blank
            return
        }

        guard let number = Double(value), number > 0 else {
            dosageErrorMessage = "Dosage must be a positive number."
            return
        }

        dosageErrorMessage = nil // Clear error if valid
    }
}

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

