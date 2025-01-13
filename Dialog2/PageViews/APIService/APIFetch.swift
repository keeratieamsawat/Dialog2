// Extension of the 'APIService' class to perform GET requests with optional Bearer token authentication.
// This utility handles decoding JSON responses into specified `Codable` types.

import Foundation

extension APIService {
    // Performs a GET request to the specified endpoint we have defined at the backend, and decodes the response into the specified type.
    // Parameters:
    ///   - endpoint: The URL string for the API endpoint
    ///   - token: Optional Bearer token for authentication
    ///   - responseType: The type of the expected response, conforming to 'Codable'
    ///   - completion: A closure that returns a 'Result' with the decoded response or an error
    
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    func get<T: Codable>(
        endpoint: String,
        token: String?,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Validate and create the URL
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // HTTP GET method
        if let token = token {
            // Add Bearer token for authorization if provided
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        /* end of reference 1 */

        // Perform the network call
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any errors in the request
            if let error = error {
                completion(.failure(error))
                return
            }

            // Test if the data is received
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }

            // Decode the response data into the asked data type
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse)) // Return the decoded response
            } catch {
                completion(.failure(error)) // Return decoding error
            }
        }.resume()
    }
}
