//
//  PurchaseView.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import SwiftUI

struct PurchaseView: View {
    static let userActivity = "com.aaplab.app.purchase"
    let product: Product = Product()

    @State private var isPurchaseLinkActivated = false

    var body: some View {
        VStack {
            Text(product.title)
            NavigationLink(isActive: $isPurchaseLinkActivated) {
                Text("Check out view: ")
                    .padding()
            } label: {
                Label("Go to checkout", systemImage: "creditcard")
                    .padding()
            }
        }
        .userActivity(
            PurchaseView.userActivity,
            isActive: isPurchaseLinkActivated
        ) { userActivity in
            userActivity.title = "Purchase \(product.title)"
            userActivity.userInfo = ["id": product.id]
        }
    }
}
