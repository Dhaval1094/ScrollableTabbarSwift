//
//  UserDetailsViewModelTests.swift
//  AsyncTestCasesTests
//
//  Created by Dhaval Trivedi on 06/07/23.
//

import XCTest
@testable import AsyncTestCases

final class UserDetailsViewModelTests: XCTestCase {
    
    let sut = UserDetailsViewModel()
    
    let url = "https://api.nationalize.io/?name=james"
    var testData = Data()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockAPIClient.self]
        if let bundlePath = Bundle.main.path(forResource: "UserData", ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            XCTAssertNotNil(bundlePath, "Bundle path should be not nil")
            XCTAssertNotNil(jsonData, "Json data should be not nil")
            testData = jsonData
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetUserDetails() async {
        let expectation = expectation(description: "Get users")
        guard let url = URL.init(string: url) else {
            XCTFail("Not valid URL")
            return
        }
        mockApiRequest(url: url, data: testData)
        Task {
            do {
                try await sut.getUserDetails(name: "james")
                XCTAssertEqual(sut.user.name, "james")
                expectation.fulfill()
            } catch {
                XCTFail(APIClient.AppError.invalidJSONFormat.localizedDescription)
            }
        }
        
//        Instance method ‘wait’ is unavailable from asynchronous contexts; Use await fulfillment(of:timeout:enforceOrder:) instead; this is an error in Swift 6
        
        await fulfillment(of: [expectation])
    }
}
