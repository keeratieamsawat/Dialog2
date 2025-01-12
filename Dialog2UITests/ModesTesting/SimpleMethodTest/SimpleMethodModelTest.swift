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
