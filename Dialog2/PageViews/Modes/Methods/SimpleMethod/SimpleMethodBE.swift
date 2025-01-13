import Foundation
import SwiftUI

// This ViewModel is responsible for the Simple method, including managing the blood sugar section, food section, and sending the data to the backend.
// This code receives data that the user inputs from the SimpleMethodView(UI)

// MARK: - ViewModel for Simple Method
class SimpleMethodBE: ObservableObject {

    // MARK: - Dependencies
    private let apiService: AppAPIServiceProtocol // Use protocol for flexibility

    // MARK: - Published Properties
    @Published var selectedDate = Date()
    @Published var bloodSugarTime = Date()
    @Published var bloodSugarLevel: String = ""
    @Published var mealTiming: String = ""
    @Published var noteBloodSugar: String = ""
    @Published var selectedMeal: String = ""
    @Published var foodTime = Date()
    @Published var food: String = ""
    @Published var caloriesIntake: String = ""
    @Published var carbohydrateIntake: String = ""
    @Published var noteFood: String = ""
    @Published var isBloodSugarOutOfRange: Bool = false
    @Published var bloodSugarAlert: BloodSugarAlert?
    @Published var errorMessage: String? // To display error messages

    // MARK: - Initializer
    init(apiService: AppAPIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    // MARK: - Blood Sugar Check
    func checkBloodSugarStatus() {
        // Validate that the blood sugar level is a valid number
        guard let bloodSugar = Double(bloodSugarLevel), bloodSugar > 0 else {
            errorMessage = "Invalid blood sugar level entered."
            return
        }

        isBloodSugarOutOfRange = BloodSugarManager.shared.checkBloodSugarStatus(
            bloodSugarLevel: bloodSugarLevel,
            mealTiming: mealTiming
        )

        if isBloodSugarOutOfRange {
            bloodSugarAlert = BloodSugarManager.shared.getBloodSugarAlert(
                bloodSugarLevel: bloodSugarLevel,
                mealTiming: mealTiming
            )
            // Trigger doctor alert if blood sugar is out of range
            triggerDoctorAlert(bloodSugarLevel: bloodSugarLevel)
        } else {
            bloodSugarAlert = nil
        }
    }

    func triggerDoctorAlert(bloodSugarLevel: String) {
        let alertPayload: [String: String] = [
            "userid": "7808aba7-6ae4-4603-a408-560308d08ecc",
            "bloodSugarLevel": bloodSugarLevel
        ]
        
        apiService.post(
            endpoint: "http://127.0.0.1:5000/alert-doctor",
            payload: alertPayload,
            token: TokenManager.getToken(),
            responseType: AlertDoctorResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Doctor alerted successfully: \(response.message), Status: \(response.status)")
                case .failure(let error):
                    print("Error alerting doctor: \(error.localizedDescription)")
                    self.errorMessage = "Failed to alert doctor. Please try again later."
                }
            }
        }
    }

    // MARK: - Send Data to Backend
    func sendDataToBackend() {
        guard let bloodSugar = Double(bloodSugarLevel), bloodSugar > 0 else {
            errorMessage = "Please enter a valid blood sugar level."
            return
        }

        let userID = "7808aba7-6ae4-4603-a408-560308d08ecc"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []

        let fieldMappings: [(key: String, value: String?, date: Date)] = [
            ("selectedDateSimple", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
            ("bloodSugarTimeSimple", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
            ("foodTimeSimple", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
            ("bloodSugar", bloodSugarLevel, bloodSugarTime),
            ("mealTimingSimple", mealTiming, selectedDate),
            ("noteBloodSugarSimple", noteBloodSugar, selectedDate),
            ("selectedMealSimple", selectedMeal, foodTime),
            ("foodSimple", food, foodTime),
            ("caloriesIntakeSimple", caloriesIntake, foodTime),
            ("carbohydrateIntakeSimple", carbohydrateIntake, foodTime),
            ("noteFoodSimple", noteFood, foodTime)
        ]

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

        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)

        apiService.post(
            endpoint: "http://127.0.0.1:5000/conditions",
            payload: payload,
            token: TokenManager.getToken(),
            responseType: Response.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Data sent successfully: \(response)")
                case .failure(let error):
                    print("Error sending data: \(error.localizedDescription)")
                    self.errorMessage = "Failed to send data. Please check your internet connection."
                }
            }
        }
    }
}














