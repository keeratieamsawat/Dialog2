import SwiftUI

struct AppDataView: View {
    var body: some View {
        VStack {
            Text("Export Data")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This feature is under development")
                .font(.body)
                .padding()
        }
        .navigationTitle("App Data Management")
    }
}

struct AppDataView_Previews: PreviewProvider {
    static var previews: some View {
        AppDataView()
    }
}
