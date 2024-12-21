import SwiftUI

struct ExerciseStatView: View {
    var body: some View {
        VStack {
            Text("Exercise Data")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("This feature will track exercise duration and type.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Exercise Stats")
        .padding()
    }
}
