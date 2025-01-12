import SwiftUI

struct IntensiveView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = IntensiveMethodViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50)
                    Spacer()
                    Text("Intensive Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {} // Placeholder for symmetry
                        .frame(width: 50)
                }
                .padding(.horizontal, 13)
                .padding(.top, 40)
            }

            // Scrollable Content
            ScrollView {
                VStack(spacing: 15) {
                    Text("Ideal refining lifestyle or treatment strategies to improve diabetes management")
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

                    // Carb Bolus Insulin Section
                    CarbInsulinSection(
                        carbBolusDosage: $viewModel.carbBolusDosage,
                        carbBolusTiming: $viewModel.carbBolusTiming,
                        carbBolusNote: $viewModel.carbBolusNote
                    )

                    // High Blood Sugar Insulin Section
                    HighBSInsulinSection(
                        highBSBolusInsulinDose: $viewModel.highBSBolusInsulinDose,
                        highBSBolusInsulinTiming: $viewModel.highBSBolusInsulinTiming,
                        highBSBolusInsulinNote: $viewModel.highBSBolusInsulinNote
                    )

                    // Ketone Section
                    KetoneSection(
                        ketoneValue: $viewModel.ketoneValue,
                        ketoneTiming: $viewModel.ketoneTiming,
                        ketoneNote: $viewModel.ketoneNote
                    )

                    // Basal Insulin Section
                    BasalRateSection(
                        basalValue: $viewModel.basalValue,
                        basalTiming: $viewModel.basalTiming,
                        basalNote: $viewModel.basalNote
                    )

                    // Exercise Section
                    ExerciseSection(
                        exerciseName: $viewModel.exerciseName,
                        duration: $viewModel.duration,
                        intensity: $viewModel.intensity
                    )

                    // Unusual Events Section
                    UnusualEventSection(
                        selectedIllness: $viewModel.selectedIllness,
                        selectedStress: $viewModel.selectedStress,
                        selectedSkippedMeal: $viewModel.selectedSkippedMeal,
                        selectedMedicationChange: $viewModel.selectedMedicationChange,
                        selectedTravel: $viewModel.selectedTravel,
                        unusualEventNote: $viewModel.unusualEventNote
                    )

                    // Apply Button
                    Button(action: {
                        viewModel.sendDataToBackend()
                        //viewModel.checkBloodSugarStatus() // Check if blood sugar is out of range
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
                .padding(.bottom, 20)
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

struct IntensiveView_Previews: PreviewProvider {
    static var previews: some View {
        IntensiveView()
    }
}

