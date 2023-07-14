//
//  AppStateResoration_SwiftUIApp.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import SwiftUI

@main
struct AppStateResoration_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            // For scene storage
            AirplaneTrips()
            // For user activity
//            RootView()                .userActivity(PurchaseView.userActivity) { userActivity in
//                guard let userInfo = userActivity.userInfo else {
//                    return
//                }
//            }
//            .onContinueUserActivity(PurchaseView.userActivity) { userActivity in
//                guard let userInfo = userActivity.userInfo else {
//                    return
//                }
//            }
        }
    }
}
