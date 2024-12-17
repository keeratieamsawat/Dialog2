// JavaCakes!
// Created by Chen Fan on 08/12/2024.

// Main pages and sign-in/create account pages.

import SwiftUI

struct InfoPageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40.0) {
                
                // image of JavaCakes logo
                Image("JavaCakes")
                    .resizable() // allows resizing
                    .scaledToFit() // maintains aspect ratio
                    .frame(width: 200, height: 200) // adjust width and height as needed

                // image of DiaLog logo
                Image("DiaLog_Logo")
                    .resizable() // allows resizing
                    .scaledToFit() // maintains aspect ratio
                    .frame(width: 300, height: 200) // adjust width and height as needed
                    .offset(y:-80)
                
                // texts on the main page
                Text("Welcome!")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color("Primary_Color"))
                    .offset(y:-140)
                
                Text("Set up your personal digital diabetic logbook.")
                    .font(.body)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.black)
                    .offset(y:-160)
                
                // "Get Started" button
                // clicking on it navigates to log-in page
                NavigationLink(destination: LoginView()) {
                    Text("Get Started")
                        .bold()
                        .frame(maxWidth:.infinity,minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color("Primary_Color"))
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                        .offset(y:-160)
                }
            }
        }
    }
}

struct LoginView: View {
    var body: some View {
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
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color("Primary_Color"))
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
            
            // "Sign-in": prompt exisiting user to sign in
            // this button goes to sign-in page
            NavigationLink(destination: SignInView()) {
                Text("Sign-in")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal,40)
            }
            
        }
        // align all contents to the top of page
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

struct CreateAccountView: View {
    @State private var firstName: String = "" // Binding to store user input
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // First Name Label and TextField for input
            Text("First Name:")
                .font(.headline)
            
            TextField("Enter your first name", text: $firstName)
                .padding() // Adds padding inside the TextField
                .background(Color.gray.opacity(0.1)) // Background color to make the field noticeable
                .cornerRadius(8) // Rounded corners for the TextField
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Standard border style for TextField

            // Display entered text
            Text("You entered: \(firstName)")
                .padding(.top, 20)
            
            Spacer() // Pushes content upwards
        }
        .padding(40) // Padding around the VStack to avoid content being too close to the edges
    }
}

struct SignInView: View {
    var body: some View {
        Text("Sign In Page")
            .font(.largeTitle)
    }
}

#Preview {
    InfoPageView()
}
