import SwiftUI

struct MedicationStatView: View {
    var body: some View {
        VStack {
            Text("Medication Intake Data")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Medication intake tracking feature is coming soon.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Medication Stats")
        .padding()
    }
}
