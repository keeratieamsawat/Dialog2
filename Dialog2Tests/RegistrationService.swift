import SwiftUI
@testable import Dialog2

class RegistrationService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func sendRegistrationData(userData: UserRegistrationData, completion: @escaping (Result<String, Error>) -> Void) {
        // Prepare the data to send
        let registrationData: [String: Any] = [
            "first_name": userData.firstName,
            "last_name": userData.lastName,
            "email": userData.userEmail,
            "password": userData.password,
            "confirm_password": userData.confirmPassword,
            "gender": userData.gender,
            "birthdate": DateUtils.formattedDate(from: userData.birthDate, format: "yyyy-MM-dd"),
            "country_of_residence": userData.country,
            "emergency_contact": userData.emergContact,
            "weight": userData.weight,
            "height": userData.height,
            "consent": userData.consentStatus
        ]

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

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                completion(.success(responseString))
            }
        }

        task.resume()
    }
}
