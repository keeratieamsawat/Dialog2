import Foundation

class TokenManager {
    static func getToken() -> String? {
        // Example: Retrieve the stored JWT token securely (e.g., from UserDefaults or Keychain)
        return UserDefaults.standard.string(forKey: "jwt_token")
    }
}
