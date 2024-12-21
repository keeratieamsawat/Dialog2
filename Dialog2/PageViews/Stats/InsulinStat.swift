import SwiftUI

struct InsulinStatView: View {
    var body: some View {
        VStack {
            Text("Insulin Intake Statistics")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("This feature is coming soon!")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Insulin Stats")
        .padding()
    }
}
