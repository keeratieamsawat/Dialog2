import SwiftUI

// This is the UI section displaying the Comprehensive Method. The data received from this page will be managed by ComprehensiveMethodBE.

struct ComprehensiveMethodView: View {
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the current view (go back to main page)
    @StateObject private var viewModel = ComprehensiveMethodViewModel() // ViewModel instance for managing data
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Bar
            ZStack {
                Color("Primary_Color") // Set background color for the top bar
                    .frame(height: 120) // Define the height of the top bar
                    .edgesIgnoringSafeArea(.top) // Allow the top bar to extend to the top edge of the screen

                HStack {
                    // Close Icon on the Left
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the current view
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white) // Color of the close button
                    }
                    .frame(width: 50) // Fixed width for the button

                    Spacer() // Adds space between the close button and title

                    // Title in the Middle
                    Text("Comprehensive Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Title color
                        .frame(maxWidth: .infinity, alignment: .center) // Center the title
                    Spacer() // Adds space between the title and the next button
                    
                    // Invisible Button for layout balancing
                    Button(action: {}) {}
                        .frame(width: 50)
                }
                .padding(.horizontal, 13) // Add horizontal padding
                .padding(.top, 40) // Add top padding to avoid overlap with status bar
            }

            // MARK: - Scrollable Content
            ScrollView {
                VStack(spacing: 10) {
                    // Main description text
                    Text("Comprehensive method for managing diabetes with detailed tracking")
                        .font(.system(size: 16))
                        .fontWeight(.semibold) // Semi-bold font for description
                        .foregroundColor(.black) // Text color
                        .multilineTextAlignment(.center) // Center the description text
                        .padding(.horizontal) // Padding around the description text
                        .padding(.top, 20) // Top padding to separate from other elements
                    
                    // MARK: - User Input Sections
                    
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

                    // Apply Button to submit the data
                    Button(action: {
                        viewModel.sendDataToBackend() // Send data to backend
                        viewModel.checkBloodSugarStatus() 
                    }) {
                        Text("APPLY")
                            .font(.headline) // Font style for button text
                            .foregroundColor(.white) // Text color
                            .padding() // Padding around the text
                            .frame(maxWidth: .infinity) // Make the button span the full width
                            .background(Color("Primary_Color")) // Background color
                            .cornerRadius(10) // Round the corners of the button
                            .padding(.horizontal) // Padding around the button
                    }

                    // Display alert if blood sugar is out of range
                    if viewModel.isBloodSugarOutOfRange, let alert = viewModel.bloodSugarAlert {
                        BloodSugarAlertView(alert: alert, onDismiss: {
                            viewModel.bloodSugarAlert = nil // Dismiss the alert when tapped
                        })
                        .padding() // Add padding around the alert view
                    }
                }
                .padding(.bottom, 10) // Bottom padding to avoid overlap with the bottom bar
            }
            .edgesIgnoringSafeArea([.leading, .trailing]) // Ensure the content spans the full width

            // MARK: - Bottom Bar
            ZStack {
                Color("Primary_Color") // Set background color for the bottom bar
                    .frame(height: 80) // Define the height of the bottom bar
                    .edgesIgnoringSafeArea(.bottom) // Allow the bottom bar to extend to the bottom edge
            }
        }
        .edgesIgnoringSafeArea(.all) // Ensure the entire view spans the full screen
        .navigationBarBackButtonHidden(true) // Hide the default back button in the navigation bar
    }
}

struct ComprehensiveMethodView_Previews: PreviewProvider {
    static var previews: some View {
        ComprehensiveMethodView()
    }
}


