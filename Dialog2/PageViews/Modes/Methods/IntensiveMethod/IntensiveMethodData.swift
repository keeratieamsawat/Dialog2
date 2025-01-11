import Foundation

struct IntensiveMethodData: Codable {
    let mode: String
    let selectedDate: String
    let bloodSugarTime: String
    let bloodSugarLevel: String
    let mealTiming: String
    let noteBloodSugar: String
    
    let selectedMeal: String
    let foodTime: String
    let food: String
    let caloriesIntake: String
    let carbohydrateIntake: String
    let noteFood: String
    
    let carbBolusDosage: String
    let carbBolusTiming: String
    let carbBolusNote: String
    
    let highBSBolusInsulinDose: String
    let highBSBolusInsulinTiming: String
    let highBSBolusInsulinNote: String
    
    let ketoneValue: String
    let ketoneTiming: String
    let ketoneNote: String
    
    let basalValue: String
    let basalTiming: String
    let basalNote: String
    
    let exerciseName: String
    let duration: String
    let intensity: String
    
    let selectedIllness: String?
    let selectedStress: String?
    let selectedSkippedMeal: String?
    let selectedMedicationChange: String?
    let selectedTravel: String?
    let unusualEventNote: String
    
    let isBloodSugarOutOfRange: Bool
    let bloodSugarAlert: BloodSugarAlert?
}


