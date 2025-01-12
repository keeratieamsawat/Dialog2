import Foundation
import SwiftUI

// MARK: - ViewModel for Simple Method
class SimpleMethodViewModel: ObservableObject {
    
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

    // MARK: - Blood Sugar Check
    func checkBloodSugarStatus() {
        isBloodSugarOutOfRange = BloodSugarManager.shared.checkBloodSugarStatus(
            bloodSugarLevel: bloodSugarLevel,
            mealTiming: mealTiming
        )

        if isBloodSugarOutOfRange {
            bloodSugarAlert = BloodSugarManager.shared.getBloodSugarAlert(
                bloodSugarLevel: bloodSugarLevel,
                mealTiming: mealTiming
            )
            // triggerDoctorAlert(bloodSugarLevel: bloodSugarLevel) // Uncomment if needed
        } else {
            bloodSugarAlert = nil
        }
    }

    // MARK: - Send Data to Backend
    func sendDataToBackend() {
        let userID = "eaba7c23-3bc4-4d56-943c-fc5a25cfbbce"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []

        // MARK: Dynamic Field Mapping
        let fieldMappings: [(key: String, value: String?, date: Date)] = [
            ("selectedDateSimple", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
            ("bloodSugarTimeSimple", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
            ("foodTimeSimple", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
            ("bloodSugarSimple", bloodSugarLevel, bloodSugarTime),
            ("mealTimingSimple", mealTiming, selectedDate),
            ("noteBloodSugarSimple", noteBloodSugar, selectedDate),
            ("selectedMealSimple", selectedMeal, foodTime),
            ("foodSimple", food, foodTime),
            ("caloriesIntakeSimple", caloriesIntake, foodTime),
            ("carbohydrateIntakeSimple", carbohydrateIntake, foodTime),
            ("noteFoodSimple", noteFood, foodTime)
        ]

        // MARK: - Create Conditions Dynamically
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

        // MARK: - Prepare the Payload
        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)

        // MARK: - API Call to Backend
        APIService.shared.post(
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
                }
            }
        }
    }
}












