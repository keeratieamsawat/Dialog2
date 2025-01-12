import XCTest
@testable import Dialog2

class IntensiveMethodViewModelTests: XCTestCase {
    
    var viewModel: IntensiveMethodViewModel!
    
    override func setUpWithError() throws {
        // Initialize the view model before each test
        viewModel = IntensiveMethodViewModel()
    }
    
    override func tearDownWithError() throws {
        // Clean up the view model after each test
        viewModel = nil
    }
    
    // MARK: - Test Data Transformation
    func testDataTransformation() throws {
        // Set properties in the view model
        viewModel.selectedDate = Date(timeIntervalSince1970: 0) // 1970-01-01
        viewModel.bloodSugarTime = Date(timeIntervalSince1970: 3600) // 1 hour later
        viewModel.bloodSugarLevel = "120"
        viewModel.mealTiming = "After breakfast"
        viewModel.noteBloodSugar = "Post-meal test"
        viewModel.selectedMeal = "Breakfast"
        viewModel.foodTime = Date(timeIntervalSince1970: 7200) // 2 hours later
        viewModel.food = "Toast"
        viewModel.caloriesIntake = "200"
        viewModel.carbohydrateIntake = "30"
        viewModel.noteFood = "Light meal"
        viewModel.carbBolusDosage = "10"
        viewModel.carbBolusTiming = Date(timeIntervalSince1970: 10800) // 3 hours later
        viewModel.carbBolusNote = "Before meal"
        viewModel.highBSBolusInsulinDose = "5"
        viewModel.highBSBolusInsulinTiming = Date(timeIntervalSince1970: 14400) // 4 hours later
        viewModel.highBSBolusInsulinNote = "Correction dose"
        viewModel.ketoneValue = "1.5"
        viewModel.ketoneTiming = Date(timeIntervalSince1970: 18000) // 5 hours later
        viewModel.ketoneNote = "After exercise"
        viewModel.basalValue = "15"
        viewModel.basalTiming = Date(timeIntervalSince1970: 21600) // 6 hours later
        viewModel.basalNote = "Night dose"
        viewModel.exerciseName = "Running"
        viewModel.duration = "30"
        viewModel.intensity = "High"
        viewModel.selectedIllness = "Flu"
        viewModel.selectedStress = "Work-related stress"
        viewModel.selectedSkippedMeal = "Breakfast"
        viewModel.selectedMedicationChange = "Missed dose"
        viewModel.selectedTravel = "Time zone change"
        viewModel.unusualEventNote = "Felt unwell"
        
        // Convert to IntensiveMethodData
        let data = viewModel.toIntensiveMethodData()
        
        // Assert the data transformation is correct
        XCTAssertEqual(data.selectedDate, "1970-01-01")
        XCTAssertEqual(data.bloodSugarTime, "01:00:00")
        XCTAssertEqual(data.bloodSugarLevel, "120")
        XCTAssertEqual(data.mealTiming, "After breakfast")
        XCTAssertEqual(data.noteBloodSugar, "Post-meal test")
        XCTAssertEqual(data.selectedMeal, "Breakfast")
        XCTAssertEqual(data.foodTime, "02:00:00")
        XCTAssertEqual(data.food, "Toast")
        XCTAssertEqual(data.caloriesIntake, "200")
        XCTAssertEqual(data.carbohydrateIntake, "30")
        XCTAssertEqual(data.noteFood, "Light meal")
        XCTAssertEqual(data.carbBolusDosage, "10")
        XCTAssertEqual(data.carbBolusTiming, "03:00:00")
        XCTAssertEqual(data.carbBolusNote, "Before meal")
        XCTAssertEqual(data.highBSBolusInsulinDose, "5")
        XCTAssertEqual(data.highBSBolusInsulinTiming, "04:00:00")
        XCTAssertEqual(data.highBSBolusInsulinNote, "Correction dose")
        XCTAssertEqual(data.ketoneValue, "1.5")
        XCTAssertEqual(data.ketoneTiming, "05:00:00")
        XCTAssertEqual(data.ketoneNote, "After exercise")
        XCTAssertEqual(data.basalValue, "15")
        XCTAssertEqual(data.basalTiming, "06:00:00")
        XCTAssertEqual(data.basalNote, "Night dose")
        XCTAssertEqual(data.exerciseName, "Running")
        XCTAssertEqual(data.duration, "30")
        XCTAssertEqual(data.intensity, "High")
        XCTAssertEqual(data.selectedIllness, "Flu")
        XCTAssertEqual(data.selectedStress, "Work-related stress")
        XCTAssertEqual(data.selectedSkippedMeal, "Breakfast")
        XCTAssertEqual(data.selectedMedicationChange, "Missed dose")
        XCTAssertEqual(data.selectedTravel, "Time zone change")
        XCTAssertEqual(data.unusualEventNote, "Felt unwell")
    }
    
    // Test blood sugar level check for being out of range
    func testBloodSugarStatus_OutOfRange_Low() {
        // Setup: Set blood sugar level to a value below the target range
        viewModel.bloodSugarLevel = "3.0"
        viewModel.mealTiming = "Pre-meal"
        
        // Call the method to check blood sugar status
        viewModel.checkBloodSugarStatus()
        
        // Assert: Blood sugar should be out of range
        XCTAssertTrue(viewModel.isBloodSugarOutOfRange)
        
        // Assert: BloodSugarAlert should be generated
        XCTAssertNotNil(viewModel.bloodSugarAlert)
        XCTAssertEqual(viewModel.bloodSugarAlert?.title, "Warning")
        XCTAssertEqual(viewModel.bloodSugarAlert?.message, "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance.")
    }
    
    func testBloodSugarStatus_OutOfRange_High() {
        // Setup: Set blood sugar level to a value above the target range
        viewModel.bloodSugarLevel = "8.0"
        viewModel.mealTiming = "Pre-meal"
        
        // Call the method to check blood sugar status
        viewModel.checkBloodSugarStatus()
        
        // Assert: Blood sugar should be out of range
        XCTAssertTrue(viewModel.isBloodSugarOutOfRange)
        
        // Assert: BloodSugarAlert should be generated
        XCTAssertNotNil(viewModel.bloodSugarAlert)
        XCTAssertEqual(viewModel.bloodSugarAlert?.title, "Warning")
        XCTAssertEqual(viewModel.bloodSugarAlert?.message, "Your blood sugar is greater than the target range. We have already emailed your doctor for further assistance.")
    }
    
    func testBloodSugarStatus_InRange() {
        // Setup: Set blood sugar level within the target range
        viewModel.bloodSugarLevel = "6.5"
        viewModel.mealTiming = "Pre-meal"
        
        // Call the method to check blood sugar status
        viewModel.checkBloodSugarStatus()
        
        // Assert: Blood sugar should be within the range
        XCTAssertFalse(viewModel.isBloodSugarOutOfRange)
        
        // Assert: BloodSugarAlert should be nil
        XCTAssertNil(viewModel.bloodSugarAlert)
    }
}



