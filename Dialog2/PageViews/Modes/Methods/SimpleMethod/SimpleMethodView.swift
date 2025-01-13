import SwiftUI

// This is the UI section displaying the Simple Method. The data received from this page will be managed by SimpleMethodBE.

struct SimpleMethodView: View {
    @Environment(\.presentationMode) var presentationMode // To manage presentation and dismissal of the view
    @StateObject private var viewModel = SimpleMethodBE() // Create and manage the view model for this view
    
    // Available meal options for selection
    let tabs = ["Breakfast", "Lunch", "Dinner", "Snack"]

    // MARK: - Customise for each Method
    var body: some View {
        VStack(spacing: 0) {
            // Top Blue Bar
            ZStack {
                Color("Primary_Color") // Set the background color for the top bar
                    .frame(height: 120) // Define the height of the bar
                    .edgesIgnoringSafeArea(.top) // Allow the bar to extend to the top of the screen

                HStack {
                    // Close Icon on the Left
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the current view when tapped
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white) // Set the color of the close icon
                    }
                    .frame(width: 50) // Ensure consistent width for the button
                    Spacer() // Add space between the close button and title

                    // Title in the Middle
                    Text("Simple Method")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center) // Center align the title
                        .padding(.leading, 10)
                    Spacer() // Add space between the title and invisible button
                    
                    // Invisible Button to Balance Layout (Empty button to balance the layout)
                    Button(action: {}) {}
                        .frame(width: 50)
                }
                .padding(.horizontal, 13) // Horizontal padding for the entire HStack
                .padding(.top, 40) // Padding for the top to avoid overlap with the status bar
                .frame(height: 120) // Set the height of the top bar
            }

            // Scrollable Content for user input
            ScrollView {
                VStack(spacing: 10) {
                    // Main Description Text
                    Text("Ideal for those with stable treatment plans or a low risk of hypoglycemia")
                        .font(.system(size: 16)) // Set font size for description
                        .fontWeight(.semibold) // Make text semi-bold
                        .foregroundColor(.black) // Text color
                        .multilineTextAlignment(.center) // Center align the text
                        .padding(.horizontal) // Horizontal padding for the description
                        .padding(.top, 20) // Top padding to separate from other elements
                    
                    // MARK: - User input Sections
                    
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

                    // Apply Button to submit the data
                    Button(action: {
                        viewModel.sendDataToBackend() // Send data to backend
                        viewModel.checkBloodSugarStatus() // Check if blood sugar is within the range
                    }) {
                        Text("APPLY")
                            .font(.headline) // Font style for the button text
                            .foregroundColor(.white) // Text color of the button
                            .padding() // Padding around the text
                            .frame(maxWidth: .infinity) // Make the button span the entire width
                            .background(Color("Primary_Color")) // Background color
                            .cornerRadius(10) // Round the corners of the button
                            .padding(.horizontal) // Padding around the button
                    }
                    
                    // If blood sugar is out of range, show an alert UI
                    if viewModel.isBloodSugarOutOfRange, let alert = viewModel.bloodSugarAlert {
                        BloodSugarAlertView(alert: alert, onDismiss: {
                            viewModel.bloodSugarAlert = nil // Dismiss alert when user taps dismiss
                        })
                        .padding() // Add padding around the alert view
                    }
                }
                .padding(.bottom, 10) // Bottom padding to avoid overlapping with the bottom bar
            }
            .edgesIgnoringSafeArea([.leading, .trailing]) // Ensure the content spans full width of the screen

            // Bottom Blue Bar
            ZStack {
                Color("Primary_Color") // Set the background color for the bottom bar
                    .frame(height: 80) // Define the height of the bottom bar
                    .edgesIgnoringSafeArea(.bottom) // Allow the bottom bar to extend to the bottom of the screen
            }
        }
        .edgesIgnoringSafeArea(.all) // Allow the content to span the entire screen, ignoring safe area
        .navigationBarBackButtonHidden(true) // Hide the back button in the navigation bar
    }
}

struct SimpleMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMethodView()
    }
}


