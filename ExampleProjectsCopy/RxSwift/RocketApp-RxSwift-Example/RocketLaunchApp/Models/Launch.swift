//
//  Launch.swift
//  RocketLaunchApp
//
//  Created by Dhaval Trivedi on 10/07/23.
//

import Foundation

class LaunchConnection: Codable {
    let __typename : String?
    let cursor : String?
    let hasMore : Bool?
    let launches : [Launches]?
}

class Launches: Codable {
    let __typename: String?
    let id: String?
    let mission: Mission?
    let site: String?
}

class Mission: Codable {
    let __typename: String?
    let missionPatch: String?
    let name: String?
    let site: String?
}
