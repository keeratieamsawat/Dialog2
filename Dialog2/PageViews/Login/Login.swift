import SwiftUI

struct LoginView: View {
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
            // align all contents to the centre of page
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    LoginView()
}
