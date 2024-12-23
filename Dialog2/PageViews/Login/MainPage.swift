// Main pages and sign-in/create account pages.

import SwiftUI

struct MainPageView: View {
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

#Preview {
    MainPageView()
}
