import SwiftUI

struct ChangePasswordView: View {
    var body: some View {
        VStack {
            Text("Change Password")
                .font(.largeTitle)
                .padding()

            // Add your content here
            Text("This is the page for change password.")
                .font(.body)
                .padding()
        }
        .navigationTitle("Change Password") // Sets the navigation title
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
