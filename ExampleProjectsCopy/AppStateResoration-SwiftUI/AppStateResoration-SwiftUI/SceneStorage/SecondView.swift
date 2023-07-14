//
//  SecondView.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import SwiftUI

struct SecondView: View {
    @State private var isShowingServicesView = false
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                isShowingServicesView = true
            } label: {
                Text("Second view")
            }
            .navigationDestination(isPresented: $isShowingServicesView) {
                ContentView()
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}

