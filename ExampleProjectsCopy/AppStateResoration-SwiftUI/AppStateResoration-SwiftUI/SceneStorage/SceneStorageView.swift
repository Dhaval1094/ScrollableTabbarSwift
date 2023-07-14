//
//  SceneStorageView.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import SwiftUI

struct SceneStorageView: View {
    @SceneStorage("selectedTab")
    private var selectedTab = 0
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                NavigationView {
                    Text("TimerView()")
                }
                .tabItem {
                    Image(systemName: "timer")
                    Text("timer")
                }
                .tag(0)
                NavigationView {
                    Text("InsightsContainerView")
                        .navigationTitle("Insights")
                }
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("insights")
                }
                .tag(1)
            }
        }
    }
}

