//
//  JSONUtils.swift
//  Dialog2
//
//  Created by Jessica Utomo on 11/01/2025.
//

import Foundation

struct JSONUtils {
    /// Encodes an encodable object into JSON data.
    ///
    
    static func fetchData(Data: [String: String], completion: @escaping ([[String: Any]]?) -> Void) {
            do {
//                // Create a mutable copy of the dictionary
//                var mutableData = Data
//                
//                // Add the userid to the dictionary
//                let userid = "1"
//                mutableData["userid"] = userid
//                print(mutableData)
                
                // Convert the updated dictionary to JSON Data
                let jsonData = try JSONUtils.dictionaryToJSONData(Data)
                
                // Send the data to the backend
                // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
                JSONUtils.sendDataToBackend(jsonData: jsonData, endpoint: "http://127.0.0.1:5000/graphs") { result in
                    switch result {
                    case .success(let response):
                        // Process the response data
                        let processedData = response.data.map { JSONUtils.convertToDictionary(dataItem: $0) }
                        DispatchQueue.main.async {
                            completion(processedData) // Pass the processed data to the completion handler
                        }
                    case .failure(let error):
                        print("Error fetching data from backend: \(error)")
                        DispatchQueue.main.async {
                            completion(nil) // Pass nil to indicate failure
                        }
                    }
                }
            } catch {
                print("Error converting dictionary to JSON: \(error.localizedDescription)")
                completion(nil) // Pass nil to indicate failure
            }
        }
    
    static func getFormattedDate(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm" // Format: yyyy-MM-DDTHH:mm
            return dateFormatter.string(from: date)
        }
    
    static func getFormattedDateHome(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Format: yyyy-MM-DDTHH:mm
            return dateFormatter.string(from: date)
        }
        

    static func combineDateAndTimeAsString(date: Date, time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format for the date part
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // Format for the time part
        
        let dateString = dateFormatter.string(from: date)
        let timeString = timeFormatter.string(from: time)
        
        return "\(dateString)T\(timeString)" // Combine with "T"
    }
    
    // Convert DataItem to a dictionary
    static func convertToDictionary(dataItem: JSONUtils.DataItem) -> [String: Any] {
        return [
            "value": dataItem.value,
            "date": dataItem.date
        ]
    }
    
    static func convertStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }
    
    static func dictionaryToJSONData(_ dictionary: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
    
    // Model for each item in the "data" array
    // Reference 2 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    struct DataItem: Decodable {
        var date: String
        var value: Double
        
        enum CodingKeys: String, CodingKey {
            case date
            case value
        }
    }
    
    // Model for the entire response
    struct BackendResponse: Decodable {
        var data: [DataItem]
    }
    
    
    /// Sends JSON data to the specified backend URL
    static func sendDataToBackend(jsonData: Data, endpoint: String, completion: @escaping (Result<BackendResponse, Error>) -> Void) {
        
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
            
            // Reference 3 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Invalid Data")
                do {
                    // If data is received, try to decode it into the BackendResponse model
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(BackendResponse.self, from: data)
                    print(responseData)
                    completion(.success(responseData)) // Return the decoded data in the completion handler
                } catch {
                    print("Error decoding response: \(error)")
                    completion(.failure(error)) // Return the decoding error in the completion handler
                }
            } else {
                // If no data is returned (empty response body), handle
                print("No data returned from the backend.")
                // Return a failure because no data was received
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }
    
}
