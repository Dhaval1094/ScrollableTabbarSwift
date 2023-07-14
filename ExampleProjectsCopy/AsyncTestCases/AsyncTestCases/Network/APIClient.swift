//
//  NetworkLayer.swift
//  AsyncTestCases
//
//  Created by Dhaval Trivedi on 06/07/23.
//

import Foundation

class APIClient: NSObject {
    static let shared = APIClient()
    let baseAPI = "https://api.nationalize.io/"
    
    enum AppError: Error {
        case invalidResponse
        case notFound
        case unexpected(code: Int)
        case invalidUrl
        case invalidJSONFormat
    }
    
    private override init() {
        super.init()
        URLProtocol.registerClass(MockAPIClient.self)
    }
    
    func fetchResponse<T: Codable>(url: URL, model: T.Type) async throws -> T? {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw AppError.invalidResponse
            }
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
          }
          catch {
            return nil
          }
    }
}
