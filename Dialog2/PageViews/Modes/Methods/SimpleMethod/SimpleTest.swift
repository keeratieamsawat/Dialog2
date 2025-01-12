import Foundation
import SwiftUI

class SimpleMethodViewModel: ObservableObject {
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
               //triggerDoctorAlert(bloodSugarLevel: bloodSugarLevel)
           } else {
               bloodSugarAlert = nil
           }
       }

    func sendDataToBackend() {
        let userID = "eaba7c23-3bc4-4d56-943c-fc5a25cfbbce"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []

        // **Dynamic Mapping**: Create field mappings
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

        // **Iterate Through Field Mappings**: Add non-empty fields to conditions
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

        // **Prepare the Payload**
        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)

        // **Send Data to the Backend**
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

