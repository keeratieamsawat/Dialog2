import SwiftUI

// This view is for inputting exercise details including
// 1. type of exercise
// 2. duration of exercise
// 3. intensity of exercise
// The section is used in ComprehensiveViewMethod and IntensiveViewMethod.

struct ExerciseSection: View {
    
    // The @Binding properties are used to pass data from the IntensiveViewMethod view and allow for changes.
    @Binding var exerciseName: String  // exercise name input
    @Binding var duration: String      // duration input
    @Binding var intensity: String     // intensity input

    @State private var errorMessage: String? // For displaying validation errors related to duration

    var body: some View {
        VStack(spacing: 10) {
            Text("EXERCISE")  // Title for the section
                .font(.headline)
                .foregroundColor(.purple)

            VStack(alignment: .leading, spacing: 10) {
                // Exercise Name Input
                HStack {
                    Text("Type of Exercise:")
                    Spacer()
                    TextField("", text: $exerciseName)  // Input for the exercise name
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Duration Input with Validation
                HStack {
                    Image(systemName: "hourglass")  // Icon for duration input
                    Text("Duration:")
                    Spacer()
                    HStack(spacing: 5) {
                        TextField("", text: $duration)  // Input for the duration of exercise
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)  // Numeric keyboard for entering duration
                            .onChange(of: duration) { newValue,_ in
                                validateDuration(newValue)  // Validates the input duration
                            }
                            .frame(maxWidth: 200)

                        Text("minutes")  // Unit label for the duration input
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                if let error = errorMessage {
                    Text(error)  // Display error message if validation fails
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 2)
                }
                
                // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com

                // Intensity Picker (Low, Medium, High)
                HStack {
                    Text("Intensity:")
                    Spacer()
                    Picker("", selection: $intensity) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(SegmentedPickerStyle())  // Segmented control style for intensity selection
                    .frame(maxWidth: 250)
                }
            }
        }
            // End of reference 1
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple.opacity(0.1)))
        .padding(.horizontal)
    }

    // MARK: - Validation Function
    private func validateDuration(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil  // No error if the input is empty
            return
        }

        guard let number = Int(value), number > 0 else {
            errorMessage = "Duration must be a positive number."  // Error message for invalid duration (input mush be positive)
            return
        }

        errorMessage = nil  // Clear error if the input is valid
    }
}

// MARK: - Preview for ExerciseSection
struct ExerciseSection_Previews: PreviewProvider {
    @State static var exerciseName = ""
    @State static var duration = ""
    @State static var intensity = ""

    static var previews: some View {
        ExerciseSection(
            exerciseName: $exerciseName,
            duration: $duration,
            intensity: $intensity
        )
        .previewLayout(.sizeThatFits)  // Show the section in a fitting preview layout
    }
}

