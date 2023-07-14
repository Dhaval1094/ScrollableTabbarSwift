//
//  ViewModel.swift
//  ActorsExample
//
//  Created by Dhaval Trivedi on 30/06/23.
//

import Foundation
enum MathFunc {
    case sum
    case mul
    case min
}
actor ActorClass {
    
    func printMyName() {
        Task {
            sleep(4)
            print("Dhaval")
        }
    }
    
    func calculate<T: Numeric>(value1: T, value2: T, math: MathFunc) -> T {
        switch math {
        case .sum:
            return value1+value2
        case .min:
            return value1-value2
        case .mul:
            return value1*value2
        }
    }
    
    func printMyPetName() {
        print("Tom")
    }
}

@MainActor class MainActorClass {
    func calculate<T: Numeric>(value1: T, value2: T, math: MathFunc) -> T {
        switch math {
        case .sum:
            return value1+value2
        case .min:
            return value1-value2
        case .mul:
            return value1*value2
        }
    }
}

@MainActor class ViewModel: ObservableObject {
    func runTest() async {
        print("1")
        await MainActor.run {
            print("2")
            Task { @MainActor in
                print("3")
            }
            print("4")
        }
        print("5")
    }
}
