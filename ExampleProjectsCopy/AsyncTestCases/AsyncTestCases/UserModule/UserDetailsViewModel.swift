//
//  UserDetailsViewModel.swift
//  AsyncTestCases
//
//  Created by Dhaval Trivedi on 06/07/23.
//

import Foundation

class UserDetailsViewModel: NSObject, ObservableObject {
    
    let client = APIClient.shared
    @Published var user: UserDetails!
    @Published var isShowIndicator = false
    
    @MainActor
    func getUserDetails(name: String = "nathan") async throws {
        isShowIndicator = true
        guard let url = URL(
            string: client.baseAPI + "?name=\(name)"
        ) else {
            isShowIndicator = false
            return
        }
        guard let result = try await client.fetchResponse(url: url, model: UserDetails.self) else {
            isShowIndicator = false
            return
        }
        user = result
        isShowIndicator = false
    }
}
