import SwiftUI

struct FoodSection: View {
    @Binding var selectedMeal: String
    @Binding var foodTime: Date
    @Binding var food: String
    @Binding var caloriesIntake: String
    @Binding var carbohydrateIntake: String
    @Binding var noteFood: String

    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 10) {
            Text("FOOD")
                .font(.headline)
                .foregroundColor(.green)

            // Tabs
            HStack(spacing: 10) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .background(selectedMeal == tab ? Color.green : Color.clear)
                        .foregroundColor(selectedMeal == tab ? .white : .green)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .onTapGesture {
                            selectedMeal = tab
                        }
                }
            }

            // Food Details
            VStack(alignment: .leading, spacing: 10) {
                // Time Picker with formatted time display
                HStack {
                    Image(systemName: "clock")
                    Text("TIME:")
                        .font(.subheadline)
                    Spacer()
                    Text(DateUtils.formattedTime(from: foodTime, format: "HH:mm"))
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                // Food TextField
                HStack {
                    Image(systemName: "fork.knife")
                    Text("Food:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $food)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Carbohydrate Intake Information in the Center of the Frame
                VStack(spacing: 5) {
                    Text("Learn more about carbohydrate intake:")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Link("Carbohydrate Intake Guide", destination: URL(string: "https://caloriecontrol.org/healthy-weight-tool-kit/food-calorie-calculator/")!)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)

                // Calories Intake TextField
                HStack {
                    Image(systemName: "chart.bar")
                    Text("Calories Intake:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $caloriesIntake)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Carbohydrate Intake TextField
                HStack {
                    Image(systemName: "chart.pie")
                    Text("Carbohydrate Intake:")
                        .font(.subheadline)
                    Spacer()
                    TextField("", text: $carbohydrateIntake)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }

                // Note TextField
                HStack {
                    Text("NOTE:")
                        .font(.subheadline)
                    Spacer()
                    TextField("Optional", text: $noteFood)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
        .padding(.horizontal)
    }
}

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
        .previewLayout(.sizeThatFits)
    }
}

