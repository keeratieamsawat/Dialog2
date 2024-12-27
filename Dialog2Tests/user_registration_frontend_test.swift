import Foundation

// Example user data (this will replace the UI inputs)
let userData: [String: Any] = [
    "first_name": "Yi",
    "last_name": "Fan",
    "email": "ginny12@ic.ac.uk",
    "password": "12",
    "confirm_password": "12",
    "gender": "Female",
    "birthdate": "1990-01-01",
    "country_of_residence": "China",
    "weight": 70,
    "height": 170,
    "consent": true
]

// Create a URL object for the API endpoint
let url = URL(string: "http://127.0.0.1:5000/register")!

// Create a URLRequest and set its method to POST
var request = URLRequest(url: url)
request.httpMethod = "POST"

// Set the Content-Type header to JSON
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

// Convert the user data dictionary to JSON
do {
    let jsonData = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
    request.httpBody = jsonData
} catch {
    print("Error serializing JSON: \(error)")
    return
}

// Send the POST request
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Error sending request: \(error)")
        return
    }

    if let response = response as? HTTPURLResponse {
        print("Response status code: \(response.statusCode)")
    }

    if let data = data {
        do {
            // Parse the response data (optional)
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("Response: \(jsonResponse)")
        } catch {
            print("Error parsing response: \(error)")
        }
    }
}

// Start the request
task.resume()
