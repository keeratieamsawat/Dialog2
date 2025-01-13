import SwiftUI

// ViewModel for managing the Intensive Method form data
struct IntensiveView: View {
    @Environment(\.presentationMode) var presentationMode // Dismiss view on button press
    @StateObject private var viewModel = IntensiveMethodViewModel() // ViewModel to manage form data

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Bar
            ZStack {
                Color("Primary_Color") // Background color for top bar
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top) // Make sure the top bar stretches to the top
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) { // Close button
                        Image(systemName: "xmark") // X mark for close action
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50) // Fixed width for the close button
                    Spacer()
                    Text("Intensive Method") // Title in the center
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {} // Placeholder button for symmetry
                        .frame(width: 50) // Fixed width for symmetry
                }
                .padding(.horizontal, 13)
                .padding(.top, 40) // Padding to position the elements
            }

            // MARK: - Scrollable Content
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

                    //  Food Section
                    FoodSection(
                        selectedMeal: $viewModel.selectedMeal,
                        foodTime: $viewModel.foodTime,
                        food: $viewModel.food,
                        caloriesIntake: $viewModel.caloriesIntake,
                        carbohydrateIntake: $viewModel.carbohydrateIntake,
                        noteFood: $viewModel.noteFood
                    )

                    // Carb Insulin Section
                    CarbInsulinSection(
                        carbBolusDosage: $viewModel.carbBolusDosage,
                        carbBolusTiming: $viewModel.carbBolusTiming,
                        carbBolusNote: $viewModel.carbBolusNote
                    )

                    //  High Blood Sugar Insulin Section
                    HighBSInsulinSection(
                        highBSBolusInsulinDose: $viewModel.highBSBolusInsulinDose,
                        highBSBolusInsulinTiming: $viewModel.highBSBolusInsulinTiming,
                        highBSBolusInsulinNote: $viewModel.highBSBolusInsulinNote
                    )

                    //  Ketone Section
                    KetoneSection(
                        ketoneValue: $viewModel.ketoneValue,
                        ketoneTiming: $viewModel.ketoneTiming,
                        ketoneNote: $viewModel.ketoneNote
                    )

                    //  Basal Insulin Section
                    BasalRateSection(
                        basalValue: $viewModel.basalValue,
                        basalTiming: $viewModel.basalTiming,
                        basalNote: $viewModel.basalNote
                    )

                    //  Exercise Section
                    ExerciseSection(
                        exerciseName: $viewModel.exerciseName,
                        duration: $viewModel.duration,
                        intensity: $viewModel.intensity
                    )

                    //  Unusual Events Section
                    UnusualEventSection(
                        selectedIllness: $viewModel.selectedIllness,
                        selectedStress: $viewModel.selectedStress,
                        selectedSkippedMeal: $viewModel.selectedSkippedMeal,
                        selectedMedicationChange: $viewModel.selectedMedicationChange,
                        selectedTravel: $viewModel.selectedTravel,
                        unusualEventNote: $viewModel.unusualEventNote
                    )

                    // MARK: - Apply Button
                    Button(action: {
                        viewModel.sendDataToBackend() // Send data to the backend
                        viewModel.checkBloodSugarStatus() // Check if blood sugar is out of range
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

                    // MARK: - Blood Sugar Alert
                    if viewModel.isBloodSugarOutOfRange, let alert = viewModel.bloodSugarAlert {
                        BloodSugarAlertView(alert: alert, onDismiss: {
                            viewModel.bloodSugarAlert = nil // Dismiss alert
                        })
                        .padding()
                    }
                }
                .padding(.bottom, 20)
            }
            .edgesIgnoringSafeArea([.leading, .trailing]) // Ignore leading and trailing safe areas
            .navigationBarBackButtonHidden(true) // Hide back button from navigation bar

            // MARK: - Bottom Bar
            ZStack {
                Color("Primary_Color")
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.bottom) // Extend the color to the bottom
            }
        }
        .edgesIgnoringSafeArea(.all) // Extend all the way to the edges of the screen
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
}

// Preview of the view
struct IntensiveView_Previews: PreviewProvider {
    static var previews: some View {
        IntensiveView() // Preview for the Intensive View
    }
}



