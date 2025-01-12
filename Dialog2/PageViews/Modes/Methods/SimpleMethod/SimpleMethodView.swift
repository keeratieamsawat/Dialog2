import SwiftUI

struct SimpleMethodView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SimpleMethodViewModel()
    
    // Selecting the meal
    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    // MARK: - Customise for each Method
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
                    
                    // MARK: - User input
                    
                    // Blood Sugar Section
                    BloodSugarSection(
                        selectedDate: $viewModel.selectedDate,
                        bloodSugarTime: $viewModel.bloodSugarTime,
                        bloodSugarLevel: $viewModel.bloodSugarLevel,
                        mealTiming: $viewModel.mealTiming,
                        noteBloodSugar: $viewModel.noteBloodSugar
                    )

                    // Food Section
                    FoodSection(
                        selectedMeal: $viewModel.selectedMeal,
                        foodTime: $viewModel.foodTime,
                        food: $viewModel.food,
                        caloriesIntake: $viewModel.caloriesIntake,
                        carbohydrateIntake: $viewModel.carbohydrateIntake,
                        noteFood: $viewModel.noteFood
                    )

                    // Apply Button
                    Button(action: {
                        viewModel.sendDataToBackend()
                        viewModel.checkBloodSugarStatus() // Check blood sugar status after the apply button is clicked
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
                    
                    // If blood sugar is out of range, display alert UI
                    if viewModel.isBloodSugarOutOfRange, let alert = viewModel.bloodSugarAlert {
                        BloodSugarAlertView(alert: alert, onDismiss: {
                            viewModel.bloodSugarAlert = nil // Dismiss alert
                        })
                        .padding()
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
        .navigationBarBackButtonHidden(true)
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}
