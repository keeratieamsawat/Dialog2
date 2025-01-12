import SwiftUI

struct ComprehensiveMethodView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ComprehensiveMethodViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50)

                    Spacer()

                    Text("Comprehensive Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {}) {}
                        .frame(width: 50)
                }
                .padding(.horizontal, 13)
                .padding(.top, 40)
            }

            // Scrollable Content
            ScrollView {
                VStack(spacing: 10) {
                    Text("Comprehensive method for managing diabetes with detailed tracking")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)

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

                    // Insulin Section
                    InsulinSection(
                        medicationName: $viewModel.medicationName,
                        insulinTiming: $viewModel.insulinTiming,
                        dosage: $viewModel.dosage,
                        insulinNote: $viewModel.insulinNote
                    )

                    // Exercise Section
                    ExerciseSection(
                        exerciseName: $viewModel.exerciseName,
                        duration: $viewModel.duration,
                        intensity: $viewModel.intensity
                    )

                    // Apply Button
                    Button(action: {
                        viewModel.sendDataToBackend()
                        viewModel.checkBloodSugarStatus() // Check blood sugar status
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

struct ComprehensiveMethodView_Previews: PreviewProvider {
    static var previews: some View {
        ComprehensiveMethodView()
    }
}
