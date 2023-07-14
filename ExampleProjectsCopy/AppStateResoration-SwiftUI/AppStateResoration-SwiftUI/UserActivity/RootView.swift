//
//  RootView.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import SwiftUI

struct RootView: View {
    @State private var isShowingServicesView = false
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                isShowingServicesView = true
            } label: {
                Text("PurchaseView")
            }
            .navigationDestination(isPresented: $isShowingServicesView) {
                PurchaseView()
            }
        }
    }
}
