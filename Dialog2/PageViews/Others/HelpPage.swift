import SwiftUI

struct HelpPage: View {
    var body: some View {
        VStack {
            Text("Help Page")
                .font(.title)
                .padding()

            Text("This is where you can provide helpful information for users.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()
        }
        .navigationTitle("Help")
    }
}
