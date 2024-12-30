import SwiftUI

struct SimpleMethodData: Codable {
    let selectedDate: String
    let bloodSugarTime: String
    let bloodSugarLevel: String
    let mealTiming : String
    let noteBloodSugar: String
    
    
    let foodTime: String
    let food: String
    let portionSize: String
    let carbohydrateIntake: String
    let noteFood: String
    let selectedTab: String
}


struct SimpleMethodView: View {
    @Environment(\.presentationMode) var presentationMode // For home page navigation

    @State private var selectedTab: String = "" // Initially empty
    @State private var selectedDate = Date()
    @State private var bloodSugarTime = Date()
    @State private var bloodSugarLevel: String = ""
    @State private var mealTiming: String = ""
    @State private var noteBloodSugar: String = ""

    @State private var foodTime = Date()
    @State private var food: String = ""
    @State private var portionSize: String = ""
    @State private var carbohydrateIntake: String = ""
    @State private var noteFood: String = ""

    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    // Close Icon on the Left
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50) // Ensure consistent spacing
                    Spacer()
                    // Title in the Middle
                    Text("Simple Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 10)
                    Spacer()
                    // Invisible Button to Balance Layout
                    Button(action: {}) {}
                        .frame(width: 50)
                }
                .padding(.horizontal, 13)
                .padding(.top, 40)
                .frame(height: 120)
            }

            // Scrollable Content
            ScrollView {
                VStack(spacing: 10) {
                    // Main Content
                    Text("Ideal for those with stable treatment plans or a low risk of hypoglycemia")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Blood Sugar Section
                    BloodSugarSection(
                        selectedDate: $selectedDate,
                        bloodSugarTime: $bloodSugarTime,
                        bloodSugarLevel: $bloodSugarLevel,
                        mealTiming: $mealTiming,
                        noteBloodSugar: $noteBloodSugar
                    )

                    // Food Section
                    FoodSection(
                        selectedTab: $selectedTab,
                        foodTime: $foodTime,
                        food: $food,
                        Calories: $portionSize,
                        carbohydrateIntake: $carbohydrateIntake,
                        tabs: tabs
                    )

                    // Apply Button
                    Button(action: {
                        sendDataToBackend()
                    }) {
                        Text("APPLY")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary_Color"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 10)
            }
            .edgesIgnoringSafeArea([.leading, .trailing])

            // Bottom Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func saveDataToJSON() -> Data? {
        let dataModel = SimpleMethodData(
            selectedDate: DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd"),
            bloodSugarTime: DateUtils.formattedTime(from: bloodSugarTime, format: "HH:mm:ss"),
            bloodSugarLevel: bloodSugarLevel,
            mealTiming : mealTiming,
            noteBloodSugar: noteBloodSugar,
            foodTime: DateUtils.formattedTime(from: foodTime, format: "HH:mm:ss"),
            food: food,
            portionSize: portionSize,
            carbohydrateIntake: carbohydrateIntake,
            noteFood: noteFood,
            selectedTab: selectedTab
        )

        return JSONUtils.encodeToJSON(dataModel)
    }

    private func sendDataToBackend() {
        guard let jsonData = saveDataToJSON() else {
            print("Failed to create JSON data")
            return
        }

        JSONUtils.sendDataToBackend(
            jsonData: jsonData,
            endpoint: "https://your-backend-api-url.com/endpoint"
        )
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}

