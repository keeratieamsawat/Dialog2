import SwiftUI

struct CarbInsulinSection: View {
    @Binding var carbBolusDosage: String
    @Binding var carbBolusTiming: Date
    @Binding var carbBolusNote: String

    @State private var errorMessage: String? // For error message display

    var body: some View {
        VStack(spacing: 10) {
            Text("CARB INSULIN")
                .font(.headline)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 10) {
                // Dosage Input with Validation
                HStack {
                    Text("DOSE (Units):")
                    Spacer()
                    HStack {
                        TextField("", text: $carbBolusDosage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Show numeric keyboard
                            .onChange(of: carbBolusDosage) { newValue in
                                validateCarbBolusDosage(newValue)
                            }
                            .frame(maxWidth: 100) // Adjust field width

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

                // Timing Picker
                HStack {
                    Image(systemName: "clock")
                    Text("Timing:")
                    Spacer()
                    DatePicker("", selection: $carbBolusTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                // Note Input
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $carbBolusNote)
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
    
    // MARK: - Validation Function
    private func validateCarbBolusDosage(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank (optional field)
            return
        }

        guard let number = Double(value), number > 0, number <= 50 else {
            errorMessage = "Invalid Input"
            return
        }

        errorMessage = nil // Clear error if valid
    }
}

struct CarbInsulinSection_Previews: PreviewProvider {
    static var previews: some View {
        CarbInsulinSection(
            carbBolusDosage: .constant(""),
            carbBolusTiming: .constant(Date()),
            carbBolusNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}

