import SwiftUI

// This section allow the user to input unusual events that they might experience.
// We decided to implement dropdown menu to enhance user friendly interface.
// This section is reused in IntensiveMethodView

// MARK: - DropdownMenu View
// This view creates a dropdown menu with a button that toggles between showing and hiding the options.

// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
struct DropdownMenu: View {
    let title: String // Title for the dropdown, displayed when no selection is made
    let options: [String] // The list of options to be displayed in the dropdown
    @Binding var selection: String? // Binding to hold the selected option
    @State private var isExpanded: Bool = false // State to track if the dropdown is expanded or collapsed

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Main Button to Toggle Dropdown
            // The main button acts as a toggle for the dropdown menu.
            Button(action: {
                // Toggle the expanded state with animation for smooth transition
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    // Display the selected option or the title if no selection is made
                    Text(selection ?? title)
                        .foregroundColor(selection == nil ? .black : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading) // Left-align the text
                        .padding(.leading, 10) // Add padding for the text
                    Spacer() // Space between text and dropdown indicator (arrow)
                    // Change the arrow direction depending on whether the dropdown is expanded
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding() // Padding for the button
                .frame(height: 50) // Fixed height for consistency
                .frame(maxWidth: .infinity) // Match the width with parent layout
                .background(Color.white) // White background for the button
                .cornerRadius(8) // Rounded corners for the button
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)) // Border for the button
            }

            // MARK: - Expanded Options
            // When the dropdown is expanded, show the list of options
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        // For each option, create a button
                        Button(action: {
                            // When an option is selected, update the selection and collapse the dropdown
                            selection = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(option) // Display the option text
                                .foregroundColor(.primary) // Primary text color
                                .padding() // Padding for the option
                                .frame(maxWidth: .infinity, alignment: .leading) // Left-align the text
                        }
                        .frame(height: 50) // Fixed height for options
                        .background(Color.white) // White background for each option
                    }
                }
                .frame(maxWidth: .infinity) // Match width with the dropdown button
                .cornerRadius(8) // Rounded corners for the dropdown list
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)) // Border for the dropdown
            }
        }
        .frame(maxWidth: .infinity) // Ensure the dropdown matches the width of its parent container
    }
}

// MARK: - UnusualEventSection View
// This view contains multiple dropdown menus for unusual events like illness, stress, and skipped meals.
struct UnusualEventSection: View {
    @Binding var selectedIllness: String? // Selected illness option
    @Binding var selectedStress: String? // Selected stress option
    @Binding var selectedSkippedMeal: String? // Selected skipped meal option
    @Binding var selectedMedicationChange: String? // Selected medication change option
    @Binding var selectedTravel: String? // Selected travel option
    @Binding var unusualEventNote: String // Notes for the unusual event

    // Predefined options for each dropdown
    let illnessOptions = ["Flu", "Fever", "Infection"]
    let stressOptions = ["Work-related stress", "Exam or school stress", "Family/Personal stress"]
    let skippedMealOptions = ["Breakfast", "Lunch", "Dinner"]
    let medicationChangeOptions = ["New medication added", "Missed dose", "Dose adjustment"]
    let travelOptions = ["Long-distance travel", "Time zone change"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Unusual Events")
                .font(.headline) // Title for the section
                .foregroundColor(.red) // Red color for the title
                .frame(maxWidth: .infinity, alignment: .center)

            // MARK: - Dropdown Menus for Each Event Type
            DropdownMenu(
                title: "Illness", // Title for the dropdown
                options: illnessOptions, // Options for illness
                selection: $selectedIllness // Binding to the selected illness
            )

            DropdownMenu(
                title: "Stress", // Title for the dropdown
                options: stressOptions, // Options for stress
                selection: $selectedStress // Binding to the selected stress
            )

            DropdownMenu(
                title: "Skipped Meal", // Title for the dropdown
                options: skippedMealOptions, // Options for skipped meals
                selection: $selectedSkippedMeal // Binding to the selected skipped meal
            )

            DropdownMenu(
                title: "Medication Change", // Title for the dropdown
                options: medicationChangeOptions, // Options for medication change
                selection: $selectedMedicationChange // Binding to the selected medication change
            )

            DropdownMenu(
                title: "Travel", // Title for the dropdown
                options: travelOptions, // Options for travel
                selection: $selectedTravel // Binding to the selected travel
            )

            // MARK: - Notes Section
            // TextField for adding additional notes related to unusual events
            VStack(alignment: .leading, spacing: 10) {
                Text("Other (Specify):") // Label for the note input
                    .font(.subheadline)
                    .foregroundColor(.primary)
                TextField("Enter additional notes", text: $unusualEventNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // TextField style
                    .padding(.horizontal) // Padding inside the text field
            }
        }
        .padding() // Padding around the entire section
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.1))) // Background for the section
        .padding(.horizontal) // Padding on the horizontal sides of the section
    }
}
//* End of reference 1

// MARK: - Preview for Unusual Event Section
// This provides a preview of the UnusualEventSection with default values
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
        .previewLayout(.sizeThatFits) // Use a layout that fits the content size
    }
}

