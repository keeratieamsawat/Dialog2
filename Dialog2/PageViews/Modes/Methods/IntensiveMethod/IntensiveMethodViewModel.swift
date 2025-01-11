import Foundation

class IntensiveMethodViewModel: ObservableObject {
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

    @Published var carbBolusDosage: String = ""
    @Published var carbBolusTiming = Date()
    @Published var carbBolusNote: String = ""

    @Published var highBSBolusInsulinDose: String = ""
    @Published var highBSBolusInsulinTiming = Date()
    @Published var highBSBolusInsulinNote: String = ""

    @Published var ketoneValue: String = ""
    @Published var ketoneTiming = Date()
    @Published var ketoneNote: String = ""

    @Published var basalValue: String = ""
    @Published var basalTiming = Date()
    @Published var basalNote: String = ""

    @Published var exerciseName: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""

    @Published var selectedIllness: String? = nil
    @Published var selectedStress: String? = nil
    @Published var selectedSkippedMeal: String? = nil
    @Published var selectedMedicationChange: String? = nil
    @Published var selectedTravel: String? = nil
    @Published var unusualEventNote: String = ""
    
    @Published var isBloodSugarOutOfRange: Bool = false
    @Published var bloodSugarAlert: BloodSugarAlert?

    func toIntensiveMethodData() -> IntensiveMethodData {
        return IntensiveMethodData(
            mode: "Intensive",
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
            carbBolusDosage: carbBolusDosage,
            carbBolusTiming: DateUtils.formattedTime(from: carbBolusTiming, format: "HH:mm:ss"),
            carbBolusNote: carbBolusNote,
            highBSBolusInsulinDose: highBSBolusInsulinDose,
            highBSBolusInsulinTiming: DateUtils.formattedTime(from: highBSBolusInsulinTiming, format: "HH:mm:ss"),
            highBSBolusInsulinNote: highBSBolusInsulinNote,
            ketoneValue: ketoneValue,
            ketoneTiming: DateUtils.formattedTime(from: ketoneTiming, format: "HH:mm:ss"),
            ketoneNote: ketoneNote,
            basalValue: basalValue,
            basalTiming: DateUtils.formattedTime(from: basalTiming, format: "HH:mm:ss"),
            basalNote: basalNote,
            exerciseName: exerciseName,
            duration: duration,
            intensity: intensity,
            selectedIllness: selectedIllness,
            selectedStress: selectedStress,
            selectedSkippedMeal: selectedSkippedMeal,
            selectedMedicationChange: selectedMedicationChange,
            selectedTravel: selectedTravel,
            unusualEventNote: unusualEventNote,
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
        let dataModel = toIntensiveMethodData()
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




