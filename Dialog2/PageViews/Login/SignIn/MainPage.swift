// MARK: main page of the app, with JavaCakes (our team name) and DiaLog logos imported as Assets on Xcode and used in this UI page

// in Assets, we uploaded the JavaCakes logo and DiaLog logo, and they can be called directly in UI pages to be added to the UI page
// we have also added "Primary Color" in the Assets, which defines the main color of our app. it is the universal blue symbol colour for diabetes

import SwiftUI

struct MainPageView: View {
    
    // this boolean variable is for navigation later. if the user is first time user, navigate to create account; if the user exists already, navigate to login
    @State private var isFirstTimeUser: Bool = UserDefaults.standard.bool(forKey: "isFirstTimeUser") != false
    @State private var navigateToCreateAccount = false
    @State private var navigateToLogin = false
    
    @StateObject var userData = UserRegistrationData()

    var body: some View {
        NavigationStack { // for nagivation to the next UI page
            VStack(spacing: 40.0) {
                // JavaCakes logo
                Image("JavaCakes")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                // DiaLog logo
                Image("DiaLog_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .offset(y: -80)
                
                // Welcome text
                Text("Welcome!")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color("Primary_Color"))
                    .offset(y: -140)
                
                // Description text
                Text("Set up your personal digital diabetic logbook.")
                    .font(.body)
                    .foregroundColor(.black)
                    .offset(y: -160)
                
// REFERENCE 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
                
                // Navigation links for dynamic navigation
                NavigationLink("", destination: CreateAccountView(userData:userData), isActive: $navigateToCreateAccount)
                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)

                // Get Started button
                Button("Get Started") {
                    if isFirstTimeUser {
                        UserDefaults.standard.set(false, forKey: "isFirstTimeUser") // Update UserDefaults
                        navigateToCreateAccount = true
                    } else {
                        navigateToLogin = true
                    }
                }
/* end of reference 1 */
                
                .bold()
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundColor(.white)
                .background(Color("Primary_Color"))
                .cornerRadius(10)
                .padding(.horizontal, 40)
                .offset(y: -250)
            }
            .padding()
        }
    }
}

#Preview {
    MainPageView()
}
