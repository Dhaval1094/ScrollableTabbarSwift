//
//  BLEConfiguration.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 21/06/23.
//

import Foundation

class ENVCharacteristics: NSObject {
    static let characteristicUUID = "0C4C3001-7700-46F4-AA96-D5E974E32A54"
    static let serviceUUID = "0C4C3000-7700-46F4-AA96-D5E974E32A54"
    static let shared = ENVCharacteristics()
    var sensorDetails = ENVSensorModel()
    let sensorName = "IM-BL01"
    var allCST = [CST]()
    override private init() {
        super.init()
        allCST = [
            .temperature,
            .rh,
            .light,
            .uvindex,
            .bp,
            .soundNoise,
            .discomfortIndex,
            .heatstrokeRiskFactor,
            .batteryVoltage
        ]
    }
    enum CST {
        case temperature
        case rh
        case light
        case uvindex
        case bp
        case soundNoise
        case discomfortIndex
        case heatstrokeRiskFactor
        case batteryVoltage
        
        var name: String {
            switch self {
            case .temperature:
                return "Temperature"
            case .rh:
                return "RH"
            case .light:
                return "Light"
            case .uvindex:
                return "UV"
            case .bp:
                return "Pressure"
            case .soundNoise:
                return "Noise"
            case .discomfortIndex:
                return ""
            case .heatstrokeRiskFactor:
                return ""
            case .batteryVoltage:
                return "Battery"
            }
        }
        var unit: String {
            switch self {
            case .temperature:
                return "ºC"
            case .rh:
                return "%"
            case .light:
                return "lx"
            case .uvindex:
                return ""
            case .bp:
                return "hPa"
            case .soundNoise:
                return "db"
            case .discomfortIndex:
                return "NA"
            case .heatstrokeRiskFactor:
                return "NA"
            case .batteryVoltage:
                return "V"
            }
        }
        var icon: String {
            switch self {
            case .temperature:
                return "ic_temp"
            case .rh:
                return "ic_humidity"
            case .light:
                return "ic_light"
            case .uvindex:
                return "ic_uv"
            case .bp:
                return "ic_pressure"
            case .soundNoise:
                return "ic_noise"
            case .discomfortIndex:
                return "NA"
            case .heatstrokeRiskFactor:
                return "NA"
            case .batteryVoltage:
                return "ic_battery"
            }
        }
    }
    func parseSensorData(data: Data) {
        let temperature = appyFormula(
            high: Double(data[2]),
            low: Double(data[1]),
            charType: .temperature
        ).roundedValue()
        let rh = appyFormula(
            high: Double(data[4]),
            low: Double(data[3]),
            charType: .rh
        ).roundedValue()
        let light = appyFormula(
            high: Double(data[5]),
            low: Double(data[6]),
            charType: .light
        ).roundedValue()
        let uvindex = appyFormula(
            high: Double(data[7]),
            low: Double(data[8]),
            charType: .uvindex
        ).roundedValue()
        let bp = appyFormula(
            high: Double(data[9]),
            low: Double(data[10]),
            charType: .bp
        ).roundedValue()
        let soundNoise = appyFormula(
            high: Double(data[11]),
            low: Double(data[12]),
            charType: .soundNoise
        ).roundedValue()
        let batteryVoltage = appyFormula(
            high: Double(data[17]),
            low: Double(data[18]),
            charType: .batteryVoltage
        ).roundedValue()
        
        sensorDetails.temperature = "\(temperature) \(CST.temperature.unit)"
        
        sensorDetails.relativeHumidity = "\(rh) \(CST.rh.unit)"
        
        sensorDetails.light = "\(light) \(CST.light.unit)"
        
        sensorDetails.uvIndex = "\(uvindex) \(CST.uvindex.unit)"
        
        sensorDetails.barrowMetricPressure = "\(bp) \(CST.bp.unit)"
       
        sensorDetails.soundNoise = "\(soundNoise) \(CST.soundNoise.unit)"
        
        sensorDetails.batteryVoltage = "\(batteryVoltage) \(CST.batteryVoltage.unit)"
    }
    func appyFormula(high: Double, low: Double, charType: CST) -> Double {
        switch charType {
        case .temperature,
                .rh,
                .uvindex,
                .soundNoise,
                .discomfortIndex,
                .heatstrokeRiskFactor:
            return (high * 256 + low) * 0.01
        case .light:
            return (high * 256 + low)
        case .bp:
            return (high * 256 + low) * 0.01
        case .batteryVoltage:
            return (high + low + 100) / 100
        }
    }
}
