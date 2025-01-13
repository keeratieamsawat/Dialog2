import SwiftUI

// A struct representing a blood sugar alert. It conforms to Identifiable and Codable protocols.
struct BloodSugarAlert: Identifiable, Codable {
    
    // Unique identifier for the alert. This allows the alert to be uniquely identified in lists or other UI components.
    var id = UUID()
    
    // The title of the alert (e.g., "Warning").
    var title: String
    
    // The message of the alert (e.g., "Your blood sugar is out of range.").
    var message: String
    
    // The title for the dismiss button in the alert (e.g., "OK, I have understood").
    var dismissButtonTitle: String // Button text to dismiss the alert
}

