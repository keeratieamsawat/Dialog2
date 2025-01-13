import SwiftUI

struct BasalRateSection: View {
    @Binding var basalValue: String
    @Binding var basalTiming: Date
    @Binding var basalNote: String

    @State private var errorMessage: String? // For showing validation errors

    var body: some View {
        VStack(spacing: 10) {
            Text("BASAL RATE")
                .font(.headline)
                .foregroundColor(.pink)
            
            VStack(alignment: .leading, spacing: 10) {
                // Basal Value Input
                HStack {
                    Text("VALUE:")
                    Spacer()
                    HStack {
                        TextField("", text: $basalValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Numeric keyboard
                            .onChange(of: basalValue) { newValue in
                                validateBasalValue(newValue)
                            }
                            .frame(maxWidth: 100) // Adjust the width as needed

                        Text("(U/H)") // Units per hour
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
                    DatePicker("", selection: $basalTiming, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                // Note Input
                HStack {
                    Image(systemName: "pencil")
                    Text("Note:")
                    Spacer()
                    TextField("Optional", text: $basalNote)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink.opacity(0.1)))
        .padding(.horizontal)
    }
    
    // MARK: - Validation Function
    private func validateBasalValue(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        guard let number = Double(value), number >= 0.1, number <= 10.0 else {
            errorMessage = "Invalid Input"
            return
        }

        errorMessage = nil // Clear error if valid
    }
}

struct BasalRateSection_Previews: PreviewProvider {
    static var previews: some View {
        BasalRateSection(
            basalValue: .constant(""),
            basalTiming: .constant(Date()),
            basalNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

