import XCTest
@testable import Dialog2

class RegistrationServiceTests: XCTestCase {
    
    var registrationService: RegistrationService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        // Create a mock session to intercept network requests
        mockSession = MockURLSession()
        registrationService = RegistrationService(session: mockSession)
    }
    
    override func tearDown() {
        registrationService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testSendRegistrationData_Success() {
        // Given
        let userData = UserRegistrationData(
            firstName: "John",
            lastName: "Doe",
            userEmail: "john.doe@example.com",
            password: "password123",
            confirmPassword: "password123",
            gender: "Male",
            birthDate: Date(),
            country: "USA",
            emergContact: "9876543210",
            weight: 75.0,
            height: 175.0,
            consentStatus: true)
        
        // Simulate a successful response
        mockSession.mockData = Data("Success".utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:5000/register")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // When
        let expectation = self.expectation(description: "Registration completion")
        
        registrationService.sendRegistrationData(userData: userData) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "Success")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSendRegistrationData_Failure_InvalidURL() {
        // Given
        let userData = UserRegistrationData(
            firstName: "John",
            lastName: "Doe",
            userEmail: "john.doe@example.com",
            password: "password123",
            confirmPassword: "password123",
            gender: "Male",
            birthDate: Date(),
            country: "USA",
            emergContact: "9876543210",
            weight: 75.0,
            height: 175.0,
            consentStatus: true)
        
        // Simulate invalid URL
        registrationService = RegistrationService(session: mockSession)
        
        // When
        let expectation = self.expectation(description: "Registration completion")
        
        registrationService.sendRegistrationData(userData: userData) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid URL, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "")
                XCTAssertEqual((error as NSError).code, -1)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSendRegistrationData_Failure_ResponseError() {
        // Given
        let userData = UserRegistrationData(
            firstName: "John",
            lastName: "Doe",
            userEmail: "john.doe@example.com",
            password: "password123",
            confirmPassword: "password123",
            gender: "Male",
            birthDate: Date(),
            country: "USA",
            emergContact: "9876543210",
            weight: 75.0,
            height: 175.0,
            consentStatus: true)
        
        // Simulate a failure response
        mockSession.mockData = nil
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "http://127.0.0.1:5000/register")!,
                                                   statusCode: 500,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        // When
        let expectation = self.expectation(description: "Registration completion")
        
        registrationService.sendRegistrationData(userData: userData) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure due to server error, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "")
                XCTAssertEqual((error as NSError).code, 500)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

// Mock URLSession class to simulate network responses
class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, mockResponse, mockError)
        return URLSessionDataTask()
    }
}
