import SwiftUI

struct DropdownMenu: View {
    let title: String
    let options: [String]
    @Binding var selection: String?
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            // Main Button to Toggle Dropdown
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection ?? title)
                        .foregroundColor(selection == nil ? .black : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                        .padding(.leading, 10) // Add padding for text
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 50) // Fixed height for consistency
                .frame(maxWidth: .infinity) // Match width with parent layout
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }

            // Expanded Options
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selection = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(option)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading) // Align text left
                        }
                        .frame(height: 50) // Match height for options
                        .background(Color.white)
                    }
                }
                .frame(maxWidth: .infinity) // Match width with the dropdown button
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity) // Ensure the dropdown matches parent width
    }
}


struct UnusualEventSection: View {
    @Binding var selectedIllness: String?
    @Binding var selectedStress: String?
    @Binding var selectedSkippedMeal: String?
    @Binding var selectedMedicationChange: String?
    @Binding var selectedTravel: String?
    @Binding var unusualEventNote: String

    let illnessOptions = ["Flu", "Fever", "Infection"]
    let stressOptions = ["Work-related stress", "Exam or school stress", "Family/Personal stress"]
    let skippedMealOptions = ["Breakfast", "Lunch", "Dinner"]
    let medicationChangeOptions = ["New medication added", "Missed dose", "Dose adjustment"]
    let travelOptions = ["Long-distance travel", "Time zone change"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Unusual Events")
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)

            // Illness Dropdown
            DropdownMenu(
                title: "Illness",
                options: illnessOptions,
                selection: $selectedIllness
            )

            // Stress Dropdown
            DropdownMenu(
                title: "Stress",
                options: stressOptions,
                selection: $selectedStress
            )

            // Skipped Meal Dropdown
            DropdownMenu(
                title: "Skipped Meal",
                options: skippedMealOptions,
                selection: $selectedSkippedMeal
            )

            // Medication Change Dropdown
            DropdownMenu(
                title: "Medication Change",
                options: medicationChangeOptions,
                selection: $selectedMedicationChange
            )

            // Travel Dropdown
            DropdownMenu(
                title: "Travel",
                options: travelOptions,
                selection: $selectedTravel
            )

            // Unusual Event Notes
            VStack(alignment: .leading, spacing: 10) {
                Text("Other (Specify):")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                TextField("Enter additional notes", text: $unusualEventNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.1)))
        .padding(.horizontal)
    }
}

// Preview for Unusual Event Section
struct UnusualEventSection_Previews: PreviewProvider {
    static var previews: some View {
        UnusualEventSection(
            selectedIllness: .constant(nil),
            selectedStress: .constant(nil),
            selectedSkippedMeal: .constant(nil),
            selectedMedicationChange: .constant(nil),
            selectedTravel: .constant(nil),
            unusualEventNote: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}
