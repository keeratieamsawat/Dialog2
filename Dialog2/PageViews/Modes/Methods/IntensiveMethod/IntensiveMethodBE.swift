import Foundation
import SwiftUI

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
    
    
    func sendDataToBackend() {
        let userID = "eaba7c23-3bc4-4d56-943c-fc5a25cfbbce"
        let timestamp = DateUtils.currentTimestamp()
        var conditions: [Condition] = []
        
        // MARK: - Field Mapping for Intensive Method
        let fieldMappings: [(key: String, value: String?, date: Date)] = [
            ("selectedDateIntensive", DateUtils.formattedDate(from: selectedDate, format: "yyyy-MM-dd'T'HH:mm:ss"), selectedDate),
            ("bloodSugarTimeIntensive", DateUtils.formattedDate(from: bloodSugarTime, format: "yyyy-MM-dd'T'HH:mm:ss"), bloodSugarTime),
            ("foodTimeIntensive", DateUtils.formattedDate(from: foodTime, format: "yyyy-MM-dd'T'HH:mm:ss"), foodTime),
            ("bloodSugarIntensive", bloodSugarLevel, bloodSugarTime),
            ("mealTimingIntensive", mealTiming, selectedDate),
            ("noteBloodSugarIntensive", noteBloodSugar, selectedDate),
            ("carbBolusDosageIntensive", carbBolusDosage, carbBolusTiming),
            ("carbBolusNoteIntensive", carbBolusNote, carbBolusTiming),
            ("highBSBolusInsulinDoseIntensive", highBSBolusInsulinDose, highBSBolusInsulinTiming),
            ("highBSBolusInsulinNoteIntensive", highBSBolusInsulinNote, highBSBolusInsulinTiming),
            ("ketoneValueIntensive", ketoneValue, ketoneTiming),
            ("ketoneNoteIntensive", ketoneNote, ketoneTiming),
            ("basalValueIntensive", basalValue, basalTiming),
            ("basalNoteIntensive", basalNote, basalTiming),
            ("exerciseNameIntensive", exerciseName, basalTiming),
            ("unusualEventNoteIntensive", unusualEventNote, selectedDate)
        ]
        
        // MARK: - Add Conditions Dynamically
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
        
        // MARK: - Add Optional Booleans or Enums
        let optionalFields: [(key: String, value: String?)] = [
            ("selectedIllnessIntensive", selectedIllness),
            ("selectedStressIntensive", selectedStress),
            ("selectedSkippedMealIntensive", selectedSkippedMeal),
            ("selectedMedicationChangeIntensive", selectedMedicationChange),
            ("selectedTravelIntensive", selectedTravel)
        ]
        
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
        
        // MARK: - Prepare Payload and Send
        let payload = ConditionHelper.preparePayload(userId: userID, conditions: conditions)
        
        // Debug: Log payload for validation
        print("Payload conditions: \(conditions)")
        
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








