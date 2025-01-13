import SwiftUI

// MARK: - BasalRateSection View

// BasalRateSection is a view to handle input related to basal levels, Basal recorded time and basal notes. This section is used in IntensiveMethodView.

struct BasalRateSection: View {
    
    // Binding to basal value, basal timing, basal note (input from intensiveMethodView)
    @Binding var basalValue: String // 
    @Binding var basalTiming: Date
    @Binding var basalNote: String

    @State var errorMessage: String? // State for showing validation errors on input

    var body: some View {
        VStack(spacing: 10) {
            Text("BASAL RATE") // Title of the section
                .font(.headline)
                .foregroundColor(.pink)
            
            // * Reference 1 - OpenAI. (2024). ChatGPT (v. 4). Retrieved from https://chat.openai.com
            VStack(alignment: .leading, spacing: 10) {
                // Basal Value Input
                HStack {
                    Text("VALUE:") // Label for basal value
                    Spacer()
                    HStack {
                        TextField("", text: $basalValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad) // Numeric keyboard for entering decimal values
                            .onChange(of: basalValue) { newValue,_ in
                                // Validate input whenever it changes
                                validateBasalValue(newValue)
                            }
                            .frame(maxWidth: 100) // Limit the width of the text field

                        Text("(U/H)") // Unit for basal value (Units per hour)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
            // *End of reference 1

                // Display error message if validation fails
                if let error = errorMessage {
                    Text(error) // Show validation error
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }

                // Time Picker for selecting basal timing
                HStack {
                    Image(systemName: "clock") // Icon for time picker
                    Text("Time:") // Label for time input
                    Spacer()
                    DatePicker("", selection: $basalTiming, displayedComponents: .hourAndMinute) // Date picker for time selection
                        .labelsHidden()
                }
                
                // Note Input for optional comments
                HStack {
                    Image(systemName: "pencil") // Icon for note input
                    Text("Note:") // Label for the note input
                    Spacer()
                    TextField("Optional", text: $basalNote) // Text field for optional notes
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink.opacity(0.1))) // Background with rounded corners and pink color
        .padding(.horizontal)
    }
    
    // MARK: - Validation Function
    // Function to validate the basal value input
    func validateBasalValue(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        // Check if the input is a valid number within the range of 0.1 to 10.0
        guard let number = Double(value), number >= 0.1, number <= 10.0 else {
            errorMessage = "Invalid Input" // Show error if input is not a valid number
            return
        }

        errorMessage = nil // Clear error if the input is valid
    }
}

// MARK: - Preview for BasalRateSection
// This preview renders the BasalRateSection for previewing purposes.
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



