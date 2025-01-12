import Foundation

struct SimpleMethodData: Codable {
    let mode: String // Identifier for the mode
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
    
    let isBloodSugarOutOfRange: Bool
    let bloodSugarAlert: BloodSugarAlert?
    
    
    }


