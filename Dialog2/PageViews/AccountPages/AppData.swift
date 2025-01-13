// Page view to manage app-related data, such as exporting user data (Still under development)

import SwiftUI

struct AppDataView: View {
    var body: some View {
        VStack {
            // Title for the view
            Text("Export Data")
                .font(.largeTitle)
                .padding()

            // Placeholder content for under-development features
            Text("This feature is under development")
                .font(.body)
                .padding()
        }
        .navigationTitle("App Data Management") // Navigation title for the view
    }
}

struct AppDataView_Previews: PreviewProvider {
    static var previews: some View {
        AppDataView()
    }
}

