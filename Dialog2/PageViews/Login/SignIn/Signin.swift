// MARK: the sign-in page takes in user email and password for those users who has already registered

// Each user email and password should be unique and corresponds to a unique personal token in backend - this allows each user to sign-in to their own account

import SwiftUI

struct SigninView: View {
    
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var accessToken: String? = nil // when login successful, store access token
    @State private var navigateToHome: Bool = false // boolean variable to conditionally navigate to HomePageView
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign-In to Your Account")
                    .font(.title)
                    .bold()
                
                // user input their registered email and password
                Text("User Email:")
                    .font(.headline)
                TextField("Enter your registration email", text: $userEmail)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2)
                    )
                    .offset(y: -10)
                
                Text("Password:")
                    .font(.headline)
                SecureField("Enter your password", text: $password)
                    .padding(10)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Primary_Color"), lineWidth: 2)
                    )
                    .offset(y: -10)
                
               // login button
                Button(action: {
                    // calling the login function (written below)
                    loginUser(email: userEmail, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 45)
                        .background(Color("Primary_Color"))
                        .cornerRadius(8)
                }
                
               // display login message - success/error
                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .font(.subheadline)
                        .foregroundColor(loginMessage.contains("success") ? .green : .red)
                        .padding(.top, 10)
                }
                
                // navigation link for home page
                NavigationLink(destination: HomePageView(diabetesData:DiabetesDetailsData()), isActive: $navigateToHome) {
                    EmptyView() // make sure the navigation link does not show anything on the view page
                }
            }
            .padding(40)
        }
    }
    
// MARK: loginUser function to handle user login, send login request to backend.
// Backend will check if email and password are already stored in database, and allow the user to continue to their account if so
    
// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    // similar code being used in DoctorInfo and ConsentsView pages as well
    
    func loginUser(email: String, password: String) {
        
        // backend databse URL, with "login" being the endpoint
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            loginMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // prepare email and password to send to server
        let loginData: [String: String] = ["email": email, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: []) else {
            loginMessage = "Failed to encode request data"
            return
        }
        request.httpBody = httpBody
        
        // sending email and password user input to server
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    loginMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    loginMessage = "Invalid server response"
                }
                return
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if httpResponse.statusCode == 200 {
                        if let responseDict = jsonResponse as? [String: Any],
                           let message = responseDict["message"] as? String,
                           let token = responseDict["access_token"] as? String {
                            DispatchQueue.main.async {
                                loginMessage = message
                                accessToken = token
                                navigateToHome = true
                                // set boolean value to be true, to navigate to HomePageView after success in login
                            }
                        } else {
                            DispatchQueue.main.async {
                                loginMessage = "Invalid response format"
                            }
                        }
                    } else if let responseDict = jsonResponse as? [String: Any],
                              let errorMessage = responseDict["error"] as? String {
                        DispatchQueue.main.async {
                            loginMessage = errorMessage
                        }
                    } else {
                        DispatchQueue.main.async {
                            loginMessage = "Unexpected error"
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        loginMessage = "Failed to decode response"
                    }
                }
            }
        }
        task.resume()
    }
}

/* end of reference 1 */

#Preview {
    SigninView()
}

