import SwiftUI

struct BasicTherapyInfoView: View {
    var body: some View {
        VStack {
            Text("Basic Therapy Info")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for Basic Therapy Info.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Basic Therapy Info") // Sets the navigation title
    }
}

struct BasicTherapyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTherapyInfoView()
    }
}
