import Foundation
import SwiftUI

// BloodSugarManager: A singleton class to manage blood sugar levels and alerts.
class BloodSugarManager {

    // Singleton instance of BloodSugarManager
    static let shared = BloodSugarManager()

    private init() {} // Private initializer to prevent external instantiation

    // MARK: - Check Blood Sugar Status

    // Checks if the blood sugar level is outside the target range based on meal timing
    func checkBloodSugarStatus(
        bloodSugarLevel: String,  // Blood sugar level as a string
        mealTiming: String        // Meal timing: either "Pre-meal" or "Post-meal"
    ) -> Bool {
        guard let bloodSugar = Double(bloodSugarLevel) else {
            return false // Invalid input
        }

        // Define threshold values for hypoglycemia and hyperglycemia
        let thresholds: (low: Double, preMealHigh: Double, postMealHigh: Double) = (low: 4.0, preMealHigh: 7.0, postMealHigh: 11.0)

        // Check if the blood sugar is out of range for pre-meal or post-meal timings
        if mealTiming == "Pre-meal" {
            return bloodSugar < thresholds.low || bloodSugar > thresholds.preMealHigh
        } else if mealTiming == "Post-meal" {
            return bloodSugar < thresholds.low || bloodSugar > thresholds.postMealHigh
        }

        return false // Assume blood sugar is in range if meal timing is not recognized
    }

    // MARK: - Get Blood Sugar Alert

    // Returns an alert if the blood sugar level is outside the target range
    func getBloodSugarAlert(
        bloodSugarLevel: String,  // Blood sugar level as a string
        mealTiming: String        // Meal timing: either "Pre-meal" or "Post-meal"
    ) -> BloodSugarAlert? {
        guard let bloodSugar = Double(bloodSugarLevel) else {
            return nil // Return nil if the blood sugar level is invalid
        }

        // Define threshold values for hypoglycemia and hyperglycemia
        let thresholds: (low: Double, preMealHigh: Double, postMealHigh: Double) = (low: 4.0, preMealHigh: 7.0, postMealHigh: 11.0)

        var message = "" // Variable to store the alert message
        let dismissButtonTitle = "OK, I have understood" // Button title for the alert

        // Check for pre-meal and post-meal scenarios
        if mealTiming == "Pre-meal" {
            if bloodSugar < thresholds.low {
                message = "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance."
            } else if bloodSugar > thresholds.preMealHigh {
                message = "Your blood sugar is greater than the target range. We have already emailed your doctor for further assistance."
            }
        } else if mealTiming == "Post-meal" {
            if bloodSugar < thresholds.low {
                message = "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance."
            } else if bloodSugar > thresholds.postMealHigh {
                message = "Your blood sugar is greater than the target range. We have already emailed your doctor for further assistance."
            }
        }

        // If the message is not empty, return the alert
        if !message.isEmpty {
            return BloodSugarAlert(
                title: "Warning",  // Alert title
                message: message,  // Alert message
                dismissButtonTitle: dismissButtonTitle // Button to dismiss the alert
            )
        }

        return nil // Return nil if blood sugar is within the target range
    }
}

