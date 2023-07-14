//
//  APITest.swift
//  SourceryAppTests
//
//  Created by Dhaval Trivedi on 11/07/23.
//

import XCTest
@testable import SourceryApp

final class APITest: XCTestCase {
    let httpClient = HTTPClientMock()
    lazy var sut = CurrenciesAPIService(httpClient: httpClient)
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_allCurrencies_withMalformedData_returnsError() throws {
        httpClient.executeRequestCompletionClosure = { _, completion in
            completion(.success(Data()))
        }
        var result: Result<[CurrencyDTO], Error>?
        sut.allCurrencies { result = $0 }
        XCTAssertThrowsError(try result?.get())
    }
}
