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
    
    // MARK: storing user inputs to the create account pages

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userEmail: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
            
            // texts on the create account page
            HStack {
                Text("Step 1 of 3")
                    .font(.subheadline)
                Spacer() // HStack spacer to push stuff to the left
            }
            Text("Create an Account")
                .font(.title)
                .bold() // Make it bold
            
            // MARK: text fields to intake user inputs for creating account
            
            // first name
            Text("First Name:")
                .font(.headline)
            // textfield: allow user input
            TextField("Enter your first name", text: $firstName)
                .padding(10) // padding inside textfield to make it smaller
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

struct PersonalInfoView: View {
// MARK: storing user inputs to the create account pages

    @State private var gender: String = ""
    @State private var birthDate: Date = Date()
    @State private var country: String = ""
    @State private var emergContact: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
            
            // texts on the create account page
            HStack {
                Text("Step 2 of 3")
                    .font(.subheadline)
                Spacer() // HStack spacer to push stuff to the left
            }
            Text("Personal Information")
                .font(.title)
                .bold() // Make it bold
            
// MARK: text fields to intake user inputs for creating account
            
            // gender
            Text("Gender:")
                .font(.headline)
            TextField("Your gender", text: $gender)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
                .offset(y:-10)
            
            // birth date
            Text("Birth Date:")
                .font(.headline)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("Primary_Color"), lineWidth: 2)
                
                DatePicker(
                    "Select your birthday",
                    selection: $birthDate,
                    displayedComponents: [.date])
                .padding(10)
            }
            .frame(height:20)
                .datePickerStyle(CompactDatePickerStyle())
            
            // country of residence
            Text("Country of Residence:")
                .font(.headline)
                .offset(y:10)
            TextField("Enter your country of residence", text: $country)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            // emergency contact details
            Text("Emergency Contact:")
                .font(.headline)
                .offset(y:10)
            TextField("Enter the details of your emergency contact", text: $emergContact)
                .padding(10)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Primary_Color"), lineWidth: 2))
            
            // button to direct to next page
            NavigationLink(destination: PersonalInfoView()) {
                Text("Final Step")
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

struct SignInView: View {
    var body: some View {
        Text("Sign In Page")
            .font(.largeTitle)
    }
}

#Preview {
    PersonalInfoView()
}
