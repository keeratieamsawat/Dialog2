import XCTest
@testable import Dialog2

class BloodSugarManagerTests: XCTestCase {
    
    var bloodSugarManager: BloodSugarManager!

    override func setUpWithError() throws {
        // Initialize the bloodSugarManager before each test
        bloodSugarManager = BloodSugarManager.shared
    }

    override func tearDownWithError() throws {
        // Clean up after each test
        bloodSugarManager = nil
    }

    // Test when blood sugar is low for Pre-meal timing
    func testLowBloodSugar_PreMeal() {
        let bloodSugarLevel = "3.5"
        let mealTiming = "Pre-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Warning")
        XCTAssertEqual(alert?.message, "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance.")
        XCTAssertEqual(alert?.dismissButtonTitle, "OK, I have understood")
    }

    // Test when blood sugar is high for Pre-meal timing
    func testHighBloodSugar_PreMeal() {
        let bloodSugarLevel = "8.0"
        let mealTiming = "Pre-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Warning")
        XCTAssertEqual(alert?.message, "Your blood sugar is greater than the target range. We have already emailed your doctor for further assistance.")
        XCTAssertEqual(alert?.dismissButtonTitle, "OK, I have understood")
    }

    // Test when blood sugar is low for Post-meal timing
    func testLowBloodSugar_PostMeal() {
        let bloodSugarLevel = "3.5"
        let mealTiming = "Post-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Warning")
        XCTAssertEqual(alert?.message, "Your blood sugar is lower than the target range. We have already emailed your doctor for further assistance.")
        XCTAssertEqual(alert?.dismissButtonTitle, "OK, I have understood")
    }

    // Test when blood sugar is high for Post-meal timing
    func testHighBloodSugar_PostMeal() {
        let bloodSugarLevel = "12.0"
        let mealTiming = "Post-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Warning")
        XCTAssertEqual(alert?.message, "Your blood sugar is greater than the target range. We have already emailed your doctor for further assistance.")
        XCTAssertEqual(alert?.dismissButtonTitle, "OK, I have understood")
    }

    // Test when blood sugar is within the target range (Pre-meal)
    func testBloodSugarInRange_PreMeal() {
        let bloodSugarLevel = "6.5"
        let mealTiming = "Pre-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNil(alert)
    }

    // Test when blood sugar is within the target range (Post-meal)
    func testBloodSugarInRange_PostMeal() {
        let bloodSugarLevel = "9.0"
        let mealTiming = "Post-meal"
        
        let alert = bloodSugarManager.getBloodSugarAlert(bloodSugarLevel: bloodSugarLevel, mealTiming: mealTiming)
        
        XCTAssertNil(alert)
    }
}







