import SwiftUI

struct CreateAccountView: View {
    
// MARK: storing user input
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userEmail: String = ""
    @State private var password: String = ""
    
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
                TextField("Enter your first name", text: $firstName)
                    .padding(10) // the padding inside textfield
                    .frame(height: 40) // set smaller height/size for the textfield
                    .overlay( // user .overlay to add round rectangle border to textfield
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10) // push the textfield a bit upwards
                
                // last name
                Text("Last Name:")
                    .font(.headline)
                TextField("Enter your last name", text: $lastName)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // user email
                Text("Email Address:")
                    .font(.headline)
                TextField("Enter your email", text: $userEmail)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // password
                Text("Password:")
                    .font(.headline)
                TextField("Create your password", text: $password)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2))
                    .offset(y:-10)
                
                // button to direct to next page
                NavigationLink(destination: PersonalInfoView()) {
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


#Preview {
    CreateAccountView()
}
