import Foundation
import SwiftUI

// This ViewModel is responsible for the Comprehensive method, including managing the blood sugar section, food section, insulin section, exercise section, and sending the data to the backend.
// This code receives data that the user inputs from the ComprehensiveMethodView(UI)

class ComprehensiveMethodViewModel: ObservableObject {

    // MARK: - Dependencies
    
    private let apiService: AppAPIServiceProtocol // Use protocol for flexibility, allows mocking or testing with different implementations of the API service.

    // MARK: - Published Properties (State Variables)
    // Blood Sugar related properties
    @Published var selectedDate = Date()
    @Published var bloodSugarTime = Date()
    @Published var bloodSugarLevel: String = ""
    @Published var mealTiming: String = ""
    @Published var noteBloodSugar: String = ""

    // Food related properties
    @Published var selectedMeal: String = ""
    @Published var foodTime = Date()
    @Published var food: String = ""
    @Published var caloriesIntake: String = ""
    @Published var carbohydrateIntake: String = ""
    @Published var noteFood: String = ""

    // Insulin related properties
    @Published var medicationName: String = ""
    @Published var dosage: String = ""
    @Published var insulinTiming = Date()
    @Published var insulinNote: String = ""

    // Exercise related properties
    @Published var exerciseName: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""

    // Blood sugar alert and error handling
    @Published var isBloodSugarOutOfRange: Bool = false
    @Published var bloodSugarAlert: BloodSugarAlert?
    @Published var errorMessage: String? 

    // MARK: - Initializer
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
    init(apiService: AppAPIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    // MARK: - Blood Sugar Check
    func checkBloodSugarStatus() {
        // Validate that the blood sugar level is a valid number
        guard let bloodSugar = Double(bloodSugarLevel), bloodSugar > 0 else {
            errorMessage = "Invalid blood sugar level entered." // Show an error message if the input is invalid
            return
        }

        // Check if the blood sugar level is within the expected range (using a shared BloodSugarManager)
        isBloodSugarOutOfRange = BloodSugarManager.shared.checkBloodSugarStatus(
            bloodSugarLevel: bloodSugarLevel,
            mealTiming: mealTiming
        )

        // If the blood sugar is out of range, get the alert and trigger the doctor alert
        if isBloodSugarOutOfRange {
            bloodSugarAlert = BloodSugarManager.shared.getBloodSugarAlert(
                bloodSugarLevel: bloodSugarLevel,
                mealTiming: mealTiming
            )
            triggerDoctorAlert(bloodSugarLevel: bloodSugarLevel) // Send alert to doctor if blood sugar is abnormal
        } else {
            bloodSugarAlert = nil // Reset alert if the blood sugar is within the normal range
        }
    }

    // MARK: - Trigger Doctor Alert
    func triggerDoctorAlert(bloodSugarLevel: String) {
        // Create the payload to be sent in the doctor alert
        let alertPayload: [String: String] = [
            "userid": "7808aba7-6ae4-4603-a408-560308d08ecc", // Hardcoded userID for now
            "bloodSugarLevel": bloodSugarLevel // The blood sugar level to be sent to the doctor
        ]

        // Send the alert to the doctor via an API POST request
        apiService.post(
            endpoint: "http://127.0.0.1:5000/alert-doctor", // Endpoint for doctor alert
            payload: alertPayload, // The payload containing the alert data
            token: TokenManager.getToken(), // Use the authentication token
            responseType: AlertDoctorResponse.self // Expected response type
        ) { result in
            DispatchQueue.main.async {
                // Handle the API response
                switch result {
                case .success(let response):
                    print("Doctor alerted successfully: \(response.message), Status: \(response.status)") // Log success
                case .failure(let error):
                    print("Error alerting doctor: \(error.localizedDescription)") // Log error
                    self.errorMessage = "Failed to alert doctor. Please try again later." // Show an error message to the user
                }
            }
        }
    }

    // MARK: - Send Data to Backend
    func sendDataToBackend() {
        // Validate blood sugar level before proceeding
        guard let bloodSugar = Double(bloodSugarLevel), bloodSugar > 0 else {
            errorMessage = "Please enter a valid blood sugar level." // Show error if the blood sugar is invalid
            return
        }

        // Define a user ID (hardcoded for now)
        let userID = "7808aba7-6ae4-4603-a408-560308d08ecc"
        let timestamp = DateUtils.currentTimestamp() // Get current timestamp for data logging
        var conditions: [Condition] = [] // Initialize an empty array for conditions

        // Define a set of field mappings (fields to be sent to the backend)
        let fieldMappings: [(key: String, value: String?, date: Date)] = [
            ("selectedDateComprehensive", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
            ("bloodSugarTimeComprehensive", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
            ("foodTimeComprehensive", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
            ("insulinTimingComprehensive", DateUtils.formattedDate(from: insulinTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), insulinTiming),
            ("bloodSugar", bloodSugarLevel, bloodSugarTime),
            ("mealTimingComprehensive", mealTiming, selectedDate),
            ("noteBloodSugarComprehensive", noteBloodSugar, selectedDate),
            ("selectedMealComprehensive", selectedMeal, foodTime),
            ("foodComprehensive", food, foodTime),
            ("caloriesIntakeComprehensive", caloriesIntake, foodTime),
            ("carbohydrateIntakeComprehensive", carbohydrateIntake, foodTime),
            ("noteFoodComprehensive", noteFood, foodTime),
            ("medicationNameComprehensive", medicationName, insulinTiming),
            ("dosageComprehensive", dosage, insulinTiming),
            ("insulinNoteComprehensive", insulinNote, insulinTiming),
            ("exerciseNameComprehensive", exerciseName, selectedDate),
            ("durationComprehensive", duration, selectedDate),
            ("intensityComprehensive", intensity, selectedDate)
        ]

        // Loop through the field mappings and create conditions dynamically
        for field in fieldMappings {
            if let value = field.value, !value.isEmpty {
                conditions.append(ConditionHelper.createCondition(
                    userId: userID,
                    dataType: field.key,
                    value: value,
                    date: field.date,
                    timestamp: timestamp
                ))
            }
        }

        // Prepare the payload to be sent to the backend
        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)

        // Send the data to the backend using the API service
        apiService.post(
            endpoint: "http://127.0.0.1:5000/conditions", // Backend endpoint for sending conditions data
            payload: payload, // The payload containing the user's data
            token: TokenManager.getToken(), // Authentication token
            responseType: Response.self // Expected response type from the backend
        ) { result in
            DispatchQueue.main.async {
                // Handle the API response
                switch result {
                case .success(let response):
                    print("Data sent successfully: \(response)") // Log success
                case .failure(let error):
                    print("Error sending data: \(error.localizedDescription)") // Log any error
                    self.errorMessage = "Failed to send data. Please check your internet connection." // Show error message
                }
            }
        }
    }
}
//* end of reference 1 *







