import SwiftUI

struct SigninView: View {
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var accessToken: String? = nil
    @State private var navigateToHome: Bool = false // Used to navigate to HomePageView
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign-In to Your Account")
                    .font(.title)
                    .bold()

                // Email Input
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

                // Password Input
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

                // Login Button
                Button(action: {
                    loginUser(email: userEmail, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 45)
                        .background(Color("Primary_Color"))
                        .cornerRadius(8)
                }

                // Display login message
                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .font(.subheadline)
                        .foregroundColor(loginMessage.contains("success") ? .green : .red)
                        .padding(.top, 10)
                }

                // Navigate to HomePageView after successful login
                NavigationLink(destination: HomePageView(diabetesData: DiabetesDetailsData()), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .padding(40)
        }
    }

    // MARK: - Login User
    func loginUser(email: String, password: String) {
        // Backend URL
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            loginMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare email and password
        let loginData: [String: String] = ["email": email, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: []) else {
            loginMessage = "Failed to encode request data"
            return
        }
        request.httpBody = httpBody

        // Send login request
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
                                // Save the token using TokenManager
                                TokenManager.saveToken(token)
                                print("Token saved successfully: \(token)") // Debugging log

                                loginMessage = message
                                accessToken = token
                                navigateToHome = true // Navigate to the home page
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

#Preview {
    SigninView()
}
