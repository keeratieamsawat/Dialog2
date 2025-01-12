import SwiftUI

struct ExerciseSection: View {
    @Binding var exerciseName: String
    @Binding var duration: String
    @Binding var intensity: String

    @State private var errorMessage: String? // For duration validation errors

    var body: some View {
        VStack(spacing: 10) {
            Text("EXERCISE")
                .font(.headline)
                .foregroundColor(.purple)

            VStack(alignment: .leading, spacing: 10) {
                // Exercise Name Input
                HStack {
                    Text("Type of Exercise:")
                    Spacer()
                    TextField("", text: $exerciseName) // Removed placeholder
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Duration Input with Validation
                HStack {
                    Image(systemName: "hourglass")
                    Text("Duration:")
                    Spacer()
                    HStack(spacing: 5) { // Inner HStack for TextField and Unit
                        TextField("", text: $duration) // Removed placeholder
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad) // Show numeric keyboard
                            .onChange(of: duration) { newValue in
                                validateDuration(newValue)
                            }
                            .frame(maxWidth: 200)

                        Text("minutes")
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

                // Intensity Picker
                HStack {
                    Text("Intensity:")
                    Spacer()
                    Picker("", selection: $intensity) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 250)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple.opacity(0.1)))
        .padding(.horizontal)
    }

    // MARK: - Validation Function
    private func validateDuration(_ value: String) {
        guard !value.isEmpty else {
            errorMessage = nil // No error if left blank
            return
        }

        guard let number = Int(value), number > 0 else {
            errorMessage = "Duration must be a positive number."
            return
        }

        errorMessage = nil // Clear error if valid
    }
}

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
        .previewLayout(.sizeThatFits)
    }
}

