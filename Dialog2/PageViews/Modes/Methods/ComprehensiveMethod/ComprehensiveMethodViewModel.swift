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
    

    // MARK: - Transform ViewModel data to Data Model
    func toComprehensiveMethodData() -> ComprehensiveMethodData {
        return ComprehensiveMethodData(
            mode: "Comprehensive",
            selectedDate: DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd"),
            bloodSugarTime: DateUtils.formattedTime(from: bloodSugarTime, format: "HH:mm:ss"),
            bloodSugarLevel: bloodSugarLevel,
            mealTiming: mealTiming,
            noteBloodSugar: noteBloodSugar,
            selectedMeal: selectedMeal,
            foodTime: DateUtils.formattedTime(from: foodTime, format: "HH:mm:ss"),
            food: food,
            caloriesIntake: caloriesIntake,
            carbohydrateIntake: carbohydrateIntake,
            noteFood: noteFood,
            medicationName: medicationName,
            dosage: dosage,
            insulinTiming: DateUtils.formattedTime(from: insulinTiming, format: "HH:mm:ss"),
            insulinNote: insulinNote,
            exerciseName: exerciseName,
            duration: duration,
            intensity: intensity,
            isBloodSugarOutOfRange: isBloodSugarOutOfRange,
            bloodSugarAlert: bloodSugarAlert
            
        )
    }
    
    // Method to check if blood sugar is out of range
    func checkBloodSugarStatus() {
        isBloodSugarOutOfRange = BloodSugarManager.shared.checkBloodSugarStatus(
            bloodSugarLevel: bloodSugarLevel,
            mealTiming: mealTiming
        )

        // If blood sugar is out of range, generate an alert
        if isBloodSugarOutOfRange {
            bloodSugarAlert = BloodSugarManager.shared.getBloodSugarAlert(
                bloodSugarLevel: bloodSugarLevel,
                mealTiming: mealTiming
            )
        }
    }

    // MARK: - Send Data to Backend
    func sendDataToBackend() {
        let dataModel = toComprehensiveMethodData()
        let endpoint = "https://your-backend-api-url.com/simple-method"
        let token = TokenManager.getToken() // Securely retrieve the JWT token

        APIService.shared.post(
            endpoint: endpoint,
            payload: dataModel, // Payload to be sent to backend
            token: token,
            responseType: Response.self // Backend response type
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

