// MARK: this page allows new users to create account, entering their personal details. at the end of these pages, the user details will be sent to backend database and register as a new user.

import SwiftUI

struct CreateAccountView: View {
    
    // calling userData data model across all pages
    @StateObject var userData: UserRegistrationData
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
                
                // texts on the create account page
                Text("Step 1 of 3")
                    .font(.subheadline)
                
                Text("Create an Account")
                    .font(.title)
                    .bold() // Make it bold
                
                
// MARK: text fields to intake user inputs for creating account
                
                // first name
                Text("First Name:")
                    .font(.headline)
                // textfield: allow user input
                TextField("Enter your first name", text: $userData.firstName)
                    .padding(10) // the padding inside textfield
                    .frame(height: 40) // set smaller height/size for the textfield
                    .overlay( // user .overlay to add round rectangle border to textfield
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10) // using y-axis offset to push the textfield a bit upwards
                
                // last name
                Text("Last Name:")
                    .font(.headline)
                TextField("Enter your last name", text: $userData.lastName)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // user email
                Text("Email Address:")
                    .font(.headline)
                TextField("Enter your email", text: $userData.userEmail)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // password
                Text("Password:")
                    .font(.headline)
                TextField("Create your password", text: $userData.password)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // confirm password
                Text("Confirm Password:")
                    .font(.headline)
                TextField("Input your chosen password again", text: $userData.confirmPassword)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // button to direct to next page
                NavigationLink(destination: PersonalInfoView(userData:userData)) {
                    Text("Next Step")
                        .bold()
                        .frame(maxWidth:.infinity,minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color("Primary_Color"))
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                }
                
                Spacer() // VStack spacer to push contents up
            }
            .padding(40) // VStack padding to make content not touch the edges
        }
    }
}


struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(userData: UserRegistrationData())
    }
}
