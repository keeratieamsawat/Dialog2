import SwiftUI

struct FoodView: View {
    var body: some View {
        VStack {
            Text("Food settings")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for food setting info.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Food settings") // Sets the navigation title
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
