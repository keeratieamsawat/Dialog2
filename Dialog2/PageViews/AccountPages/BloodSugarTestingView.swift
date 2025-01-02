import SwiftUI

struct BloodSugarTestingView: View {
    var body: some View {
        VStack {
            Text("Blood Sugar Testing Info")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for Blood Sugar Testing Info.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Blood Sugar Testing Info") // Sets the navigation title
    }
}

struct BloodSugarTestingView_Previews: PreviewProvider {
    static var previews: some View {
        BloodSugarTestingView()
    }
}
