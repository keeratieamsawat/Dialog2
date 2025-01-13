// Model representing the standard API response structure

import Foundation

// standard API response structure
struct Response: Codable {
    let success: Bool          // Indicates whether the API request was successful
    let message: String        // Message providing additional information about the response
}
