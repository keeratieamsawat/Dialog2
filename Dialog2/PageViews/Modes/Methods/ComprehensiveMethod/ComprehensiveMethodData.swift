import Foundation

struct ComprehensiveMethodData: Codable {
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

    let medicationName: String
    let dosage: String
    let insulinTiming: String
    let insulinNote: String

    let exerciseName: String
    let duration: String
    let intensity: String
    
    let isBloodSugarOutOfRange: Bool
    let bloodSugarAlert: BloodSugarAlert?
}
