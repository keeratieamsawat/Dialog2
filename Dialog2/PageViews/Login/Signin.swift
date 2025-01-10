// the sign-in page takes in user email and password for those users who has already registered

// Each user email and password should be unique and corresponds to a unique personal token in backend - this allows each user to sign-in to their own account

import SwiftUI

struct SigninView: View {
    
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var accessToken: String? = nil  // store access token if login is successful
    @State private var navigateToHome: Bool = false  // boolean variable to conditionally navigate to HomePageView
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign-In to Your Account")
                    .font(.title)
                    .bold()
                // MARK: Text fields to intake user inputs for login
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
                
// MARK: Login Button, calling the login function
                
                Button(action: {
                    // calling login function
                    loginUser(email: userEmail, password: password)
                }) {
                    // design of the button
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 45)
                        .background(Color("Primary_Color"))
                        .cornerRadius(8)
                }
                
                // display success/failure of logging in for testing
                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .font(.subheadline)
                        .foregroundColor(loginMessage.contains("success") ? .green : .red)
                        .padding(.top, 10)
                }
                // navigate to HomePage when login is successful
                NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                    HomePageView() // activates when login is successful
                }
            }
            .padding(40)
        }
    }
    
// MARK: function for sending login request to backend
    
    func loginUser(email: String, password: String) {
        // input URL to backend server
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            loginMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // taking email and password to send to server
        let loginData: [String: String] = ["email": email, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: []) else {
            loginMessage = "Failed to encode request data"
            return
        }
        request.httpBody = httpBody
        
        // sending the request
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
            
// MARK: conditionals to handle the response for testing
            // display different messasges based on status codes
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if httpResponse.statusCode == 200 {
                        if let responseDict = jsonResponse as? [String: Any],
                           let message = responseDict["message"] as? String,
                           let token = responseDict["access_token"] as? String {
                            // Login successful, store the access token
                            DispatchQueue.main.async {
                                loginMessage = "Login successful"
                                accessToken = token  // Store the token
                            }
                        } else {
                            DispatchQueue.main.async {
                                loginMessage = "Invalid response format"
                            }
                        }
                    } else if let responseDict = jsonResponse as? [String: Any],
                              let errorMessage = responseDict["error"] as? String {
                        DispatchQueue.main.async {
                            loginMessage = errorMessage  // Show the error message from backend
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

#Preview {
    SigninView()
}
