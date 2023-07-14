//
//  ContentView.swift
//  ActorsExample
//
//  Created by Dhaval Trivedi on 30/06/23.
//

import SwiftUI

struct ContentView: View {
    var actor = ActorClass()
    @State private var actorVal = 0.0
    @State private var mainActorVal = 0.0
    var body: some View {
        VStack {
            Text("The actor value is \(actorVal)")
            Text("The actor value is \(mainActorVal)")
        }
        .onAppear {
            Task {
                await actor.printMyName()
            }
            Task {
                actorVal = await actor.calculate(value1: 6, value2: 4, math: .sum)
            }
            Task {
                await actor.printMyPetName()
            }

            mainActorVal = MainActorClass().calculate(value1: 8, value2: 9, math: .mul)
            Task {
                try await Dinner().makeDinner()
            }
        }
        .padding()
    }
}
