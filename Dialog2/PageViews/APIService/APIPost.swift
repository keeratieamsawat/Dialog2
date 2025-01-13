// Class for managing API requests (POST operations)
// Handles JSON encoding of payloads and decoding of responses into 'Codable' types

import Foundation
// Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
class APIService {
    //Shared instance of 'APIService' for global access.
    static let shared = APIService()

    // Private initializer to enforce the singleton pattern
    private init() {}

    // Performs a POST request to the specified endpoint with a JSON payload
    // Parameters - same as API Fetch
    
    func post<T: Codable, U: Codable>(
        endpoint: String,
        payload: T,
        token: String?,
        responseType: U.Type,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        /* end of reference 1 */
        
        // Validate the endpoint URL
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // Configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set JSON content type
        if let token = token {
            // Include Bearer token in headers if provided
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Encode the payload to JSON
        do {
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error)) // Handle encoding errors
            return
        }

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure response data is available
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }

            // Decode the response into the specified type
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse)) // Return the decoded response
            } catch {
                completion(.failure(error)) // Handle decoding errors
            }
        }.resume()
    }
}
