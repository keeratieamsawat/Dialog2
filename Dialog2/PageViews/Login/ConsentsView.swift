// for the consents part, the user will click the agree button, and their consent status will be sent to backend
// On clicking the button: 1) they will proceed to the next step only if consent status is true (when they click the button to agree 2) all of the registration data will be send to backend

import SwiftUI
import Foundation

// MARK: this function sends all registration data to backend database

func sendRegistrationData(userData: UserRegistrationData, completion: @escaping (Result<String, Error>) -> Void) {
    // Prepare the data to send, matching the field names from your backend
    let registrationData: [String: Any] = [
        "first_name": userData.firstName,
        "last_name": userData.lastName,
        "email": userData.userEmail,
        "password": userData.password,
        "confirm_password": userData.confirmPassword,
        "gender": userData.gender,
        "birthdate": DateUtils.formattedDate(from: userData.birthDate, format:"yy-mm-dd"),
        "country_of_residence": userData.country,
        "emergency_contact": userData.emergContact,
        "weight": userData.weight,
        "height": userData.height,
        "consent": userData.consentStatus
    ]

    // convert to JSON
    guard let url = URL(string: "http://127.0.0.1:5000/register") else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: registrationData, options: [])
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }

    // perform the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        if let data = data {
            do {
                // Assuming the backend returns a success message in the body
                let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                completion(.success(responseString))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    task.resume()
}

// MARK: ConsentsView page UI

struct ConsentsView: View {
    
    @ObservedObject var userData = UserRegistrationData()
    @State private var registrationStatusMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) { // use alignment in VStack to align everything to the left
                Text("Step 3 of 3")
                    .font(.subheadline)
                Text("Privacy & Legal Consents")
                    .font(.title)
                    .bold()
                
                Button(action: {
                    userData.consentStatus = true // navigation status set to be true, see below for navigation
                    submitConsent() // call function below to send consent status to backend
                   
                }){
                    Text("I agree to everything")
                        .bold()
                        .frame(maxWidth:.infinity,minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color("Primary_Color"))
                        .cornerRadius(10)
                        .padding(.horizontal,40)
                }
                Spacer() // VStack spacer to push contents up
            }
            .padding(30) // VStack padding to make content not touch the edges
            // navigation to DetailsPageView, when navigateToNext is true
            .navigationDestination(isPresented: $userData.consentStatus) {
                DetailsPageView()
            }
        }
    }
    
// MARK: when consent button is clicked, call function and submit request to backend
    
    func submitConsent() {
        // Send the user data to the backend
        sendRegistrationData(userData:userData) { result in
            switch result {
            case .success(let responseMessage):
                print("Registration success: \(responseMessage)")
                // Navigate to the next screen or show a success message
            case .failure(let error):
                print("Registration failed: \(error.localizedDescription)")
                // Handle failure (e.g., show an error alert)
            }
        }
    }
}

struct ConsentsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentsView(userData: UserRegistrationData())
    }
}
