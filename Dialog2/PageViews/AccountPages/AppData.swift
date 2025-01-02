import SwiftUI

struct AppDataView: View {
    var body: some View {
        VStack {
            Text("App Data Management")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for App Data Management.")
                .font(.body)
                .padding()
        }
        .navigationTitle("App Data Management") // Sets the navigation title
    }
}

struct AppDataView_Previews: PreviewProvider {
    static var previews: some View {
        AppDataView()
    }
}
