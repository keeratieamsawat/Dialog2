import Foundation

class ComprehensiveMethodViewModel: ObservableObject {
    // Blood Sugar Properties
    @Published var selectedDate = Date()
    @Published var bloodSugarTime = Date()
    @Published var bloodSugarLevel: String = ""
    @Published var mealTiming: String = ""
    @Published var noteBloodSugar: String = ""

    // Food Properties
    @Published var selectedMeal: String = ""
    @Published var foodTime = Date()
    @Published var food: String = ""
    @Published var caloriesIntake: String = ""
    @Published var carbohydrateIntake: String = ""
    @Published var noteFood: String = ""

    // Insulin Properties
    @Published var medicationName: String = ""
    @Published var dosage: String = ""
    @Published var insulinTiming = Date()
    @Published var insulinNote: String = ""

    // Exercise Properties
    @Published var exerciseName: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""

    @Published var isBloodSugarOutOfRange: Bool = false
    @Published var bloodSugarAlert: BloodSugarAlert?

    // MARK: - Send Data to Backend
    func sendDataToBackend() {
        let userID = "eaba7c23-3bc4-4d56-943c-fc5a25cfbbce"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []

        // **Dynamic Mapping**: Create field mappings
        let fieldMappings: [(key: String, value: String?, date: Date)] = [
            ("selectedDateComprehensive", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
            ("bloodSugarTimeComprehensive", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
            ("foodTimeComprehensive", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
            ("insulinTimingComprehensive", DateUtils.formattedDate(from: insulinTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), insulinTiming),
            ("bloodSugarComprehensive", bloodSugarLevel, bloodSugarTime),
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





