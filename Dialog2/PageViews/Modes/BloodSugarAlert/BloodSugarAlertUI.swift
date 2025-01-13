import SwiftUI

// A view that displays a blood sugar alert with a title, message, and dismiss button.
struct BloodSugarAlertView: View {
    
    // The alert data passed to the view
    let alert: BloodSugarAlert
    
    // A closure that is called when the dismiss button is pressed
    var onDismiss: (() -> Void)?

    var body: some View {
        VStack {
            // Title of the alert, displayed in red color and bold font
            Text(alert.title)
                .font(.title)
                .foregroundColor(.red)
                .padding()

            // Message of the alert, providing further information
            Text(alert.message)
                .padding()

            // Dismiss button, which triggers the onDismiss action when pressed
            Button(action: {
                onDismiss?()
            }) {
                Text(alert.dismissButtonTitle)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

// Preview for the BloodSugarAlertView to display the alert in SwiftUI preview
struct BloodSugarAlertView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample alert with a title, message, and dismiss button text
        let sampleAlert = BloodSugarAlert(
            title: "Warning",
            message: "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance.",
            dismissButtonTitle: "OK, I have understood"
        )

        // Display the BloodSugarAlertView with the sample alert
        BloodSugarAlertView(alert: sampleAlert) {
            print("Alert dismissed")
        }
        .previewLayout(.sizeThatFits)
        .padding() 
    }
}




