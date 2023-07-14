//
//  ContentView.swift
//  ENVSensor-BLEApp
//
//  Created by Dhaval Trivedi on 10/07/23.
//

import SwiftUI
import CoreBluetooth

struct ENVHomeView: View {
    let config = ENVCharacteristics.shared
    @StateObject var manager = ENVBluetoothManager.shared
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            switch manager.state {
            case .connected:
                Text("Connected")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
            case .connecting:
                Text("Connecting")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            case .disconnected:
                Text("Not connected")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            }
            ScrollView {
                Image("ic_env")
                    .resizable()
                    .frame(width: 320, height: 320)
                    .scaledToFill()
                    .clipped()
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(config.allCST, id: \.self) { char in
                        if char.name != "" {
                            VStack(alignment: .center) {
                                Text(char.name)
                                    .foregroundColor(.white)
//                                    .underline()
                                    .font(.title2)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                if manager.isFindData {
                                    BoxView(char: char)
                                } else {
                                    ProgressView()
                                        .tint(Color.white)
                                        .progressViewStyle(.circular)
                                }
                            }
                            .frame(minWidth: 100, idealWidth: 100, maxWidth: 200, minHeight: 200, idealHeight: 200, maxHeight: 220, alignment: .top)
                            .background(Color(UIColor.darkGray))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)                
            }
            Spacer()
        }
        .onAppear {
            manager.startScan()
            // manager.showStoredValues()
        }
    }
}

struct BoxView: View {
    @State var char: ENVCharacteristics.CST!
    var body: some View {
        Image("\(char.icon)")
            .resizable()
            .frame(width: 50, height: 50)
            .clipped()
        let details = ENVCharacteristics.shared.sensorDetails
        switch char {
        case .temperature:
            TextCharacteristicValue(value: details.temperature ?? "")
                .padding()
        case .rh:
            TextCharacteristicValue(value: details.relativeHumidity ?? "").padding()
        case .light:
            TextCharacteristicValue(value: details.light ?? "").padding()
        case .bp:
            TextCharacteristicValue(value: details.barrowMetricPressure ?? "").padding()
        case .uvindex:
            TextCharacteristicValue(value: details.uvIndex ?? "")
            if details.uvIndex?.toDouble() ?? 0 <= 5 {
                Text("Low")
                    .foregroundColor(.white)
            } else if details.uvIndex?.toDouble() ?? 0 > 5 && details.uvIndex?.toDouble() ?? 0 < 7 {
                Text("Average")
                    .foregroundColor(.white)
            } else {
                Text("High")
                    .foregroundColor(.white)
            }
        case .soundNoise:
            TextCharacteristicValue(value: details.soundNoise ?? "").padding()
        case .batteryVoltage:
            TextCharacteristicValue(value: details.batteryVoltage ?? "").padding()
        default:
            EmptyView()
        }
    }
}

struct TextCharacteristicValue: View {
    @State var value: String = ""
    var body: some View {
        Text(value)
            .foregroundColor(.white)
            .font(.system(size: 25))
            .multilineTextAlignment(.center)
    }
}
