// JavaCakes!
// Created by Chen Fan on 08/12/2024.

// Main pages and sign-in/create account pages.

import SwiftUI

struct Chen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40.0) {
                
                // image of DiaLog logo
                Image("DiaLog_Logo")
                    .imageScale(.small) // change size of image
                    .offset(y:-20) // move the image upwards
                
                // texts on the main page
                Text("Welcome!")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color("Primary_Color"))
                    .offset(y:-40)
                
                Text("Set up your personal digital diabetic logbook.")
                    .font(.body)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.black)
                    .offset(y:-40)
                
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
                        .offset(y:-40)
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
    var body: some View {
        Text("Create Account Page")
            .font(.largeTitle)
    }
}

struct SignInView: View {
    var body: some View {
        Text("Sign In Page")
            .font(.largeTitle)
    }
}

#Preview {
    ContentView()
}

