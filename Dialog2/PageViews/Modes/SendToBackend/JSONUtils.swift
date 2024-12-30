import Foundation

struct JSONUtils {
    /// Encodes an encodable object into JSON data.
    static func encodeToJSON<T: Encodable>(_ object: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(object)
            return jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return nil
        }
    }

    /// Sends JSON data to the specified backend URL.
    static func sendDataToBackend(jsonData: Data, endpoint: String) {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data to backend: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Backend response status: \(httpResponse.statusCode)")
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Backend response: \(responseString)")
            }
        }
        task.resume()
    }
}

