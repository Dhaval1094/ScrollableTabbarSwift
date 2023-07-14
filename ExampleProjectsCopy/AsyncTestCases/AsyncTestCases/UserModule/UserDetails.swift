//
//  UserDetails.swift
//  AsyncTestCases
//
//  Created by Dhaval Trivedi on 06/07/23.
//

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
    let name: String
    let country: [Country]
}

// MARK: - Country
struct Country: Codable, Hashable {
    let countryID: String
    let probability: Double

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case probability
    }
}
