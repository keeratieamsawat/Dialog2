import SwiftUI

// // This view allows users to input food-related details, including:
// 1. The meal type (e.g., Breakfast, Lunch, Dinner, Snack)
// 2. The name of the food consumed
// 3. The time the food was consumed
// 4. The calories and carbohydrate intake for the food
// 5. An optional note about the food
// Additionally, a clickable link to a carbohydrate intake guide is provided to help users understand their food's nutritional values.
// The section is designed to be reusable in SimpleMethodView, ComprehensiveMethodView and IntensiveMethodView



// MARK: - FoodSection View
struct FoodSection: View {
    //  Binding Variables for Inputs
    @Binding var selectedMeal: String  // Binding to track the selected meal (e.g., Breakfast, Lunch)
    @Binding var foodTime: Date       // Binding to track the food intake time
    @Binding var food: String         // Binding to track the food name/description
    @Binding var caloriesIntake: String // Binding to track the calories intake value
    @Binding var carbohydrateIntake: String // Binding to track the carbohydrate intake
    @Binding var noteFood: String     // Binding to track any notes related to the food

    // Meal Type Tabs (e.g., Breakfast, Lunch, Dinner)
    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 10) {
            // Section Title
            Text("FOOD")
                .font(.headline)
                .foregroundColor(.green)

            // Tabs for Meal Selection (Breakfast, Lunch, etc.)
            HStack(spacing: 10) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)  // Display each meal type
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .background(selectedMeal == tab ? Color.green : Color.clear) // Highlight selected meal type
                        .foregroundColor(selectedMeal == tab ? .white : .green)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)) // Border for tabs
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .onTapGesture {
                            selectedMeal = tab  // Set the selected meal type
                        }
                }
            }

            // Food Details Section
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Image(systemName: "clock")
                    Text("TIME:")
                        .font(.subheadline)
                    Spacer()
                    Text(DateUtils.formattedTime(from: foodTime, format: "HH:mm")) // Display time in HH:mm format
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0.2)) // Background color for time field
                        .cornerRadius(5)
                }

                // Food Name Input
                HStack {
                    Image(systemName: "fork.knife")
                    Text("Food:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $food) // Input for food name
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
                
               
                // Clickable butoon guilding to website to check food carbohydrate and calories
                // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com

                VStack(spacing: 5) {
                    Text("Learn more about carbohydrate intake:")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Link("Carbohydrate Intake Guide", destination: URL(string: "https://caloriecontrol.org/healthy-weight-tool-kit/food-calorie-calculator/")!) // External link for more information
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // End of reference 1

                // Calories Intake Input
                HStack {
                    Image(systemName: "chart.bar")
                    Text("Calories Intake:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $caloriesIntake) // Input for calories intake
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Carbohydrate Intake Input
                HStack {
                    Image(systemName: "chart.pie")
                    Text("Carbohydrate Intake:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $carbohydrateIntake) // Input for carbohydrate intake
                        .keyboardType(.numberPad) // Show numeric keyboard
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Notes Input
                HStack {
                    Text("NOTE:")
                        .font(.subheadline)
                    Spacer()
                    TextField("Optional", text: $noteFood) // Optional notes field
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1))) // Section background styling
        .padding(.horizontal)
    }
}

// MARK: - Preview for Food section

struct FoodSection_Previews: PreviewProvider {
    static var previews: some View {
        FoodSection(
            selectedMeal: .constant(""),
            foodTime: .constant(Date()),
            food: .constant(""),
            caloriesIntake: .constant(""),
            carbohydrateIntake: .constant(""),
            noteFood: .constant("")
        )
        .previewLayout(.sizeThatFits) // Preview layout
    }
}

