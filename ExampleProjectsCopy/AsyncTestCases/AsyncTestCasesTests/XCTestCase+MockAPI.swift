//
//  XCTestCase+MockAPI.swift
//  AsyncTestCasesTests
//
//  Created by Dhaval Trivedi on 10/07/23.
//

import XCTest
@testable import AsyncTestCases

extension XCTestCase {
    func mockApiRequest(url: URL, data: Data) {
        MockAPIClient.requestHandler = { request in
            guard let url = request.url else {
                throw APIClient.AppError.invalidResponse
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
}
