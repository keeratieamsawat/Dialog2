import Foundation
import SwiftUI

class BloodSugarManager {

    static let shared = BloodSugarManager() // Singleton

    private init() {}

    // Check if the blood sugar is outside of the target range
    func checkBloodSugarStatus(
        bloodSugarLevel: String,
        mealTiming: String
    ) -> Bool {
        guard let bloodSugar = Double(bloodSugarLevel) else {
            return false // Invalid input, assume within range
        }

        // Define thresholds for hyperglycemia and hypoglycemia
        let thresholds: (low: Double, preMealHigh: Double, postMealHigh: Double) = (low: 4.0, preMealHigh: 7.0, postMealHigh: 11.0)

        // Logic to check if blood sugar is out of range
        if mealTiming == "Pre-meal" {
            return bloodSugar < thresholds.low || bloodSugar > thresholds.preMealHigh
        } else if mealTiming == "Post-meal" {
            return bloodSugar < thresholds.low || bloodSugar > thresholds.postMealHigh
        }

        return false // Assume in range if mealTiming is invalid
    }

    // This function returns an alert if the blood sugar is out of range
    func getBloodSugarAlert(
        bloodSugarLevel: String,
        mealTiming: String
    ) -> BloodSugarAlert? {
        guard let bloodSugar = Double(bloodSugarLevel) else {
            return nil
        }

        let thresholds: (low: Double, preMealHigh: Double, postMealHigh: Double) = (low: 4.0, preMealHigh: 7.0, postMealHigh: 11.0)

        var message = ""
        let dismissButtonTitle = "OK, I have understood"

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

        if !message.isEmpty {
            return BloodSugarAlert(
                title: "Warning",
                message: message,
                dismissButtonTitle: dismissButtonTitle
            )
        }

        return nil // Return nil if blood sugar is within the target range
    }
}

