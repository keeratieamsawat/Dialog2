//  Utility class for managing JSON Web Tokens (JWT)
//  Provides methods to save, retrieve, clear, and decode tokens securely

import Foundation

// Manages JSON Web Tokens (JWT) for authentication.
class TokenManager {
    // MARK: - Save Token in 'UserDefaults'
    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "jwt_token")
        UserDefaults.standard.synchronize()
    }

    // MARK: - Retrieve Token
    static func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: "jwt_token")
        print("Retrieved Token: \(token ?? "nil")") // Debugging log
        return token
    }

    // MARK: - Clear Token (on logout)
    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: "jwt_token")
        UserDefaults.standard.synchronize()
    }

    // MARK: - Decode JWT to Extract User ID
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    static func getUserID() -> String? {
        guard let token = getToken() else { return nil }

        // Split the JWT into its three parts (Header, Payload, Signature)
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("Invalid JWT format")
            return nil
        }

        // The payload is the second part of the JWT
        let payload = String(parts[1])

        // Decode the payload from Base64URL format
        guard let decodedData = base64UrlDecode(payload),
              let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
              let jsonDict = json as? [String: Any] else {
            print("Failed to decode JWT payload")
            return nil
        }
        /* end of reference 1 */

        // Extract the "sub" claim (user ID), or replace with the appropriate claim key
        if let userID = jsonDict["sub"] as? String {
            return userID
        } else {
            print("User ID (sub) not found in JWT payload")
            return nil
        }
    }

    // MARK: - Helper Function: Base64URL Decode
    // Decodes a Base64URL-encoded string to 'Data'
    // Reference 2 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
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
        /* end of reference 2 */
    }
}
