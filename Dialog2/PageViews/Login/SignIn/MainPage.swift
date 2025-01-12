import SwiftUI

struct MainPageView: View {
    @State private var isFirstTimeUser: Bool = UserDefaults.standard.bool(forKey: "isFirstTimeUser") != false
    @State private var navigateToCreateAccount = false
    @State private var navigateToLogin = false
    
    @StateObject var userData = UserRegistrationData()

    var body: some View {
        NavigationStack {
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
