import SwiftUI

struct InsulinTherapyView: View {
    var body: some View {
        VStack {
            Text("Insulin Therapy Info")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for Insulin Therapy Info.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Insulin Therapy Info") // Sets the navigation title
    }
}

struct InsulinTherapyView_Previews: PreviewProvider {
    static var previews: some View {
        InsulinTherapyView()
    }
}
