import Foundation
import SwiftUI

// This ViewModel is responsible for the intensive method, including managing the blood sugar section, food section, carb insulin section, high bolus insulin section, ketone section, exercise section, unusual event section and sending the data to the backend.
// This code receives data that the user inputs from the IntensiveMethodView(UI)

class IntensiveMethodViewModel: ObservableObject {
    
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
    @Published var carbBolusDosage: String = ""
    @Published var carbBolusTiming = Date()
    @Published var carbBolusNote: String = ""
    @Published var highBSBolusInsulinDose: String = ""
    @Published var highBSBolusInsulinTiming = Date()
    @Published var highBSBolusInsulinNote: String = ""
    
    // Ketone related properties
    @Published var ketoneValue: String = ""
    @Published var ketoneTiming = Date()
    @Published var ketoneNote: String = ""
    
    // Basal related properties
    @Published var basalValue: String = ""
    @Published var basalTiming = Date()
    @Published var basalNote: String = ""
    
    // Exercise related properties
    @Published var exerciseName: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""
    
    // Additional conditions and notes
    @Published var selectedIllness: String? = nil
    @Published var selectedStress: String? = nil
    @Published var selectedSkippedMeal: String? = nil
    @Published var selectedMedicationChange: String? = nil
    @Published var selectedTravel: String? = nil
    @Published var unusualEventNote: String = ""
    
    // Alert flags
    @Published var isBloodSugarOutOfRange: Bool = false
    @Published var bloodSugarAlert: BloodSugarAlert?
    @Published var errorMessage: String? // To display error messages
    
    private let apiService: AppAPIServiceProtocol
    
    // MARK: - Initializer
    init(apiService: AppAPIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    // MARK: - Blood Sugar Check
    
    // Reference 1 - OpenAI. (2025). ChatGPT (v. 4). Retrieved from https://chat.openai.com
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
    
    // MARK: - Trigger Doctor Alert
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
    
    // MARK: - Send Data to Backend Function
    func sendDataToBackend() {
        let userID = "eaba7c23-3bc4-4d56-943c-fc5a25cfbbce"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []

        // Field mapping for Intensive Method
        let fieldMappings: [(key: String, value: String?, date: Date)] = [
                    ("selectedDateIntensive", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
                    ("bloodSugarTimeIntensive", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
                    ("foodTimeIntensive", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
                    ("bloodSugar", bloodSugarLevel, bloodSugarTime),
                    ("mealTimingIntensive", mealTiming, selectedDate),
                    ("noteBloodSugarIntensive", noteBloodSugar, selectedDate),

                    // Food related fields
                    ("selectedMealIntensive", selectedMeal, foodTime),
                    ("foodTimeIntensive", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
                    ("foodIntensive", food, foodTime),
                    ("caloriesIntakeIntensive", caloriesIntake, foodTime),
                    ("carbohydrateIntakeIntensive", carbohydrateIntake, foodTime),
                    ("noteFoodIntensive", noteFood, foodTime),

                    // Insulin related fields
                    ("carbBolusDosageIntensive", carbBolusDosage, carbBolusTiming),
                    ("carbBolusNoteIntensive", carbBolusNote, carbBolusTiming),
                    ("carbBolusTimeIntensive", DateUtils.formattedDate(from: carbBolusTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), carbBolusTiming),
                    ("highBSBolusInsulinDoseIntensive", highBSBolusInsulinDose, highBSBolusInsulinTiming),
                    ("highBSBolusInsulinNoteIntensive", highBSBolusInsulinNote, highBSBolusInsulinTiming),
                    ("highBSBolusInsulinTimingIntensive", DateUtils.formattedDate(from: highBSBolusInsulinTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), highBSBolusInsulinTiming),

                    // Ketone related fields
                    ("ketoneValueIntensive", ketoneValue, ketoneTiming),
                    ("ketoneNoteIntensive", ketoneNote, ketoneTiming),
                    ("ketoneTimingIntensive", DateUtils.formattedDate(from: ketoneTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), ketoneTiming), // ketoneTiming

                    // Basal related fields
                    ("basalValueIntensive", basalValue, basalTiming),
                    ("basalNoteIntensive", basalNote, basalTiming),
                    ("basalTimingIntensive", DateUtils.formattedDate(from: basalTiming, format: "yyyy-MM-dd'T'HH:mm:ss"), basalTiming),

                    // Exercise related fields
                    ("exerciseNameIntensive", exerciseName, basalTiming),
                    ("durationIntensive", duration, basalTiming),
                    ("intensityIntensive", intensity, basalTiming),

                    // UnusualEvent Note
                    ("unusualEventNoteIntensive", unusualEventNote, selectedDate)
                ]

        
        // Add conditions dynamically
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

        // Optional fields (illness, stress, meal skipped, etc.)
        let optionalFields: [(key: String, value: String?)] = [
            ("selectedIllnessIntensive", selectedIllness),
            ("selectedStressIntensive", selectedStress),
            ("selectedSkippedMealIntensive", selectedSkippedMeal),
            ("selectedMedicationChangeIntensive", selectedMedicationChange),
            ("selectedTravelIntensive", selectedTravel)
        ]
        
        // Add optional fields if not nil
        for field in optionalFields {
            if let value = field.value {
                conditions.append(ConditionHelper.createCondition(
                    userId: userID,
                    dataType: field.key,
                    value: value,
                    date: selectedDate,
                    timestamp: timestamp
                ))
            }
        }
        
        // Prepare and send the payload
        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)
        
        // Debug: Log payload
        print("Payload conditions: \(conditions)")
        
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
/* end of reference 1 */










