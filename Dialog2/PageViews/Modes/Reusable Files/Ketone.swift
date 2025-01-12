import SwiftUI

struct KetoneSection: View {
    @Binding var ketoneValue: String
    @Binding var ketoneTiming: Date
    @Binding var ketoneNote: String

    @State private var errorMessage: String? // For ketone value validation errors

    var body: some View {
        VStack(spacing: 10) {
            Text("KETONE")
                .font(.headline)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 10) {
                // Ketone Value Input with Validation
                HStack {
                    Text("VALUE:")
                    Spacer()
                    HStack(spacing: 5) {
                        TextField("", text: $ketoneValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Numeric keyboard
                            .onChange(of: ketoneValue) { newValue in
                                validateKetoneValue(newValue)
                            }
                            .frame(maxWidth: 100)

                        Text("mmol/L") // Units label
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

                // Ketone Timing Picker
                HStack {
                    Image(systemName: "clock")
                    Text("Time:")
                    Spacer()
                    DatePicker("", selection: $ketoneTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                // Ketone Note Input
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $ketoneNote)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
        .padding(.horizontal)
    }

    // MARK: - Validation Function
    private func validateKetoneValue(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        guard let number = Double(value), number >= 0.0, number <= 10.0 else {
            errorMessage = "Value must be a number between 0.0 and 10.0 mmol/L."
            return
        }

        errorMessage = nil // Clear error if valid
    }
}

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

