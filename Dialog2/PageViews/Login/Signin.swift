// the sign-in page takes in user email and password for those users who has already registered

// Each user email and password should be unique and corresponds to a unique personal token in backend - this allows each user to sign-in

import SwiftUI

struct SigninView:View{
    
    @State private var userEmail: String = ""
    @State private var password: String = ""
    
    var body: some View{
        NavigationStack {
            VStack(alignment:.leading,spacing:20) { // use alignment in VStack to align everything to the left
                
                Text("Sign-In to Your Account")
                    .font(.title)
                    .bold() // Make it bold
                
                
                // MARK: text fields to intake user inputs for creating account
                
                // first name
                Text("User Email:")
                    .font(.headline)
                // textfield: allow user input
                TextField("Enter your registration email", text: $userEmail)
                    .padding(10) // the padding inside textfield
                    .frame(height: 40) // set smaller height/size for the textfield
                    .overlay( // user .overlay to add round rectangle border to textfield
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10) // push the textfield a bit upwards
                
                // last name
                Text("Password:")
                    .font(.headline)
                TextField("Enter your password", text: $password)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
            }
            .padding(40)
        }
    }
}

#Preview {
    SigninView()
}
