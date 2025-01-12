import XCTest
@testable import Dialog2

class ComprehensiveMethodViewModelTests: XCTestCase {
    
    var viewModel: ComprehensiveMethodViewModel!
    
    override func setUpWithError() throws {
        // Initialize the ViewModel before each test
        viewModel = ComprehensiveMethodViewModel()
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        viewModel = nil
    }
    
    // MARK: - Test Data Transformation
    func testToComprehensiveMethodData() throws {
        // Setup the ViewModel with test data
        viewModel.selectedDate = Date(timeIntervalSince1970: 0) // 1970-01-01
        viewModel.bloodSugarTime = Date(timeIntervalSince1970: 3600) // 1 hour later
        viewModel.bloodSugarLevel = "120"
        viewModel.mealTiming = "After lunch"
        viewModel.noteBloodSugar = "Post-meal note"
        viewModel.selectedMeal = "Lunch"
        viewModel.foodTime = Date(timeIntervalSince1970: 7200) // 2 hours later
        viewModel.food = "Rice"
        viewModel.caloriesIntake = "350"
        viewModel.carbohydrateIntake = "70"
        viewModel.noteFood = "Heavy meal"
        viewModel.medicationName = "Insulin"
        viewModel.dosage = "15"
        viewModel.insulinTiming = Date(timeIntervalSince1970: 10800) // 3 hours later
        viewModel.insulinNote = "Regular dose"
        viewModel.exerciseName = "Jogging"
        viewModel.duration = "30 minutes"
        viewModel.intensity = "Moderate"
        
        // Transform the data
        let data = viewModel.toComprehensiveMethodData()
        
        // Assert that the transformed data matches the ViewModel's properties
        XCTAssertEqual(data.mode, "Comprehensive")
        XCTAssertEqual(data.selectedDate, "1970-01-01")
        XCTAssertEqual(data.bloodSugarTime, "01:00:00")
        XCTAssertEqual(data.bloodSugarLevel, "120")
        XCTAssertEqual(data.mealTiming, "After lunch")
        XCTAssertEqual(data.noteBloodSugar, "Post-meal note")
        XCTAssertEqual(data.selectedMeal, "Lunch")
        XCTAssertEqual(data.foodTime, "02:00:00")
        XCTAssertEqual(data.food, "Rice")
        XCTAssertEqual(data.caloriesIntake, "350")
        XCTAssertEqual(data.carbohydrateIntake, "70")
        XCTAssertEqual(data.noteFood, "Heavy meal")
        XCTAssertEqual(data.medicationName, "Insulin")
        XCTAssertEqual(data.dosage, "15")
        XCTAssertEqual(data.insulinTiming, "03:00:00")
        XCTAssertEqual(data.insulinNote, "Regular dose")
        XCTAssertEqual(data.exerciseName, "Jogging")
        XCTAssertEqual(data.duration, "30 minutes")
        XCTAssertEqual(data.intensity, "Moderate")
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


