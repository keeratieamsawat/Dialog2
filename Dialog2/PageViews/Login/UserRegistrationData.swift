// MARK: this file creates a data model that stores locally all the registration data, and called across all registration pages
// this way, all registration data can be sent to backend database for storage (via only one request), once consent is given (consent button is clicked at the very end of the registration process)
import SwiftUI

class UserRegistrationData: ObservableObject {
    
    // the following are in CreateAccountView
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userEmail: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // the following are in PersonalInfoView
    @Published var gender: String = ""
    @Published var birthDate: Date = Date()
    @Published var country: String = ""
    @Published var emergContact: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    
    // this is for consent status in ConsentsView
    @Published var consentStatus: Bool = false
}
