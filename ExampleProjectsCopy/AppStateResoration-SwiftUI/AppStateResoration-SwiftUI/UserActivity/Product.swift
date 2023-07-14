//
//  Product.swift
//  AppStateResoration-SwiftUI
//
//  Created by Dhaval Trivedi on 13/07/23.
//

import Foundation

struct Product {
    var title = "custom product"
    var id = 87
    init(title: String = "custom product", id: Int = 87) {
        self.title = title
        self.id = id
    }
}
