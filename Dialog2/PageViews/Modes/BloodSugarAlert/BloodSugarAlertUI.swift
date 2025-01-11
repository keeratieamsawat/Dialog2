import SwiftUI

struct BloodSugarAlertView: View {
    let alert: BloodSugarAlert
    var onDismiss: (() -> Void)?

    var body: some View {
        VStack {
            Text(alert.title)
                .font(.title)
                .foregroundColor(.red) // Title in red color
                .padding()

            Text(alert.message)
                .padding()

            Button(action: {
                onDismiss?() // Close the alert when the button is pressed
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

struct BloodSugarAlertView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample alert
        let sampleAlert = BloodSugarAlert(
            title: "Warning",
            message: "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance.",
            dismissButtonTitle: "OK, I have understood"
        )

        // Display the BloodSugarAlertView with the sample alert
        BloodSugarAlertView(alert: sampleAlert) {
            print("Alert dismissed") // You can add actions when the alert is dismissed
        }
        .previewLayout(.sizeThatFits) // Preview with appropriate layout
        .padding() // Add padding to the preview
    }
}



