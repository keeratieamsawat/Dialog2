// MARK: the login page of the app, allowing new users to choose "Create Account" and existing users to choose "Sign-in"

import SwiftUI

struct LoginView: View {
    @ObservedObject var userData = UserRegistrationData() // Create the userData instance

    var body: some View {
        NavigationStack {
            VStack(spacing:30) { // organize items with spacing
                
                // have a large title on login page
                Text("Welcome to DiaLog")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color("Primary_Color"))
                    .padding(.top, 40)
                    .offset(y:-40)
                
                // create account/sign-in text
                Text("Create a new account - or sign-in if you already have one.")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,20)
                    .offset(y:-40)
                
                // "Create Account": prompt the user to create account
                // this button goes to create account page
                NavigationLink(destination: CreateAccountView(userData: userData)) { // pass userData here
                    Text("Create Account")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color("Primary_Color"))
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                }
                
                // "Sign-in": prompt existing user to sign in
                // this button goes to sign-in page
                NavigationLink(destination: SigninView()) {
                    Text("Sign-in")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                }
                
            }
            // align all contents to the centre of page
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    LoginView()
}

