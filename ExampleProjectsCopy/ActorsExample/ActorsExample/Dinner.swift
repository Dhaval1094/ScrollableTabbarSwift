//
//  Dinner.swift
//  ActorsExample
//
//  Created by Dhaval Trivedi on 03/07/23.
//

import Foundation
import UIKit

class Dinner {
        
    func makeDinner() async throws -> Meal {
        let veggies = try await chopVegetables()
        let gravy = await prepareGravy()
        let oven = try await preheatOven(temperature: 350)
        
        let dish = Dish(ingredients: [veggies, gravy])
        return try await oven.cook(dish: dish, minutes: 5)
    }
    
    /// Sequentially chop the vegetables.
    func chopVegetables() async throws -> [Vegetable] {
        let veggies: [Vegetable] = gatherRawVeggies()
      for i in veggies.indices {
          try await veggies[i].chopped()
      }
      return veggies
    }
    
    func gatherRawVeggies() -> [Vegetable] {
        return [
            Vegetable(name: "potato", category: "root"),
            Vegetable(name: "cabbage", category: "cruciferous"),
            Vegetable(name: "onion", category: "allium"),
            Vegetable(name: "garlic", category: "allium")
        ]
    }
    
    func prepareGravy() async -> Gravy {
        return Gravy(test: "spicy", color: .red)
    }
    
    func preheatOven(temperature: Int) async throws -> Oven {
        return Oven(type: "MicroWave", isHeated: true)
    }
}

struct Meal {
    var qauntity = 500 // in grams
    var test = ""
}

struct Dish {
    var ingredients = [Any]()
}

struct Oven {
    var type = ""
    var isHeated = true
    
    func cook(dish: Dish, minutes: Int) async throws -> Meal {
        return Meal(qauntity: 500, test: "spicy")
    }
}

struct Gravy {
    var test = ""
    var color = UIColor()
}

class Vegetable {
    var name = ""
    var category = ""
    var isChoped = false
    init(name: String = "", category: String = "", isChoped: Bool = false) {
        self.name = name
        self.category = category
        self.isChoped = isChoped
    }
    func chopped() async throws {
        isChoped = true
    }
}
