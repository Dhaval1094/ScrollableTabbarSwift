//
//  Extension.swift
//  ENVSensor-BLEApp
//
//  Created by Dhaval Trivedi on 11/07/23.
//

import Foundation

extension Double {
    func roundedValue() -> String {
        String(format: "%.2f", self)
    }
}

extension String {
    func toDouble() -> Double {
        Double(self) ?? 0
    }
}
