import Foundation

class TokenManager {
    // Save the token securely (e.g., after login)
    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "jwt_token")
        UserDefaults.standard.synchronize()
    }

    // Retrieve the token securely
    static func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: "jwt_token")
        print("Retrieved Token: \(token ?? "nil")") // Debugging log
        return token
    }

    // Clear the token (e.g., on logout)
    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: "jwt_token")
        UserDefaults.standard.synchronize()
    }

    // Decode JWT to extract user ID manually
    static func getUserID() -> String? {
        guard let token = getToken() else { return nil }

        // Split the JWT into its parts
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("Invalid JWT format")
            return nil
        }

        // The payload is the second part
        let payload = String(parts[1])

        // Decode the payload (Base64URL)
        guard let decodedData = base64UrlDecode(payload),
              let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
              let jsonDict = json as? [String: Any] else {
            print("Failed to decode JWT payload")
            return nil
        }

        // Extract the "sub" claim (user ID)
        if let userID = jsonDict["sub"] as? String { // Replace "sub" with the appropriate claim if needed
            return userID
        } else {
            print("User ID (sub) not found in JWT payload")
            return nil
        }
    }

    // Helper function to decode Base64URL
    private static func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Add padding if necessary
        let paddingLength = 4 - base64.count % 4
        if paddingLength < 4 {
            base64.append(String(repeating: "=", count: paddingLength))
        }

        return Data(base64Encoded: base64)
    }
}


