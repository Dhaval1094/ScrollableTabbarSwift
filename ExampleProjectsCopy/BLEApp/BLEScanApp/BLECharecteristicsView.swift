//
//  BLECharecteristicsView.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 20/06/23.
//

import SwiftUI
import CoreBluetooth

struct BLECharecteristicsView: View {
    @StateObject var bm = BLEManager.shared
    @State var service: CBService?
    @State private var selectedCharecteristic: CBCharacteristic?
    var body: some View {
        ZStack {
            VStack {
                if bm.isDiscoverCharecteristics {
                    if let charecteristics = service?.characteristics {
                        List(charecteristics, id: \.self) { charecteristic in
                            HStack {
                                Text("\(charecteristic.uuid)" + " (\(charecteristic.uuid.uuidString))")
                                    .onTapGesture {
                                        selectedCharecteristic = charecteristic
                                        bm.readValueFor(charecteristic: charecteristic, value: true)
                                    }
                            }
                        }
                    }
                }
            }
            if bm.isShowCharecteristicDetails {
                List {
                    if let charName = selectedCharecteristic?.uuid {
                        Text("\(charName.description)")
                            .font(.largeTitle)
                    }
                    Text("\(bm.charecteristicValue)")
                }
                .padding(.bottom, 16)
                Button {
                    bm.isShowCharecteristicDetails = false
//                    bm.writeValueFor(charecteristic: selectedCharecteristic!)
                } label: {
                    Text("Close")
                        .frame(width: 80, height: 50)
                        .font(.headline)
                        .background(.blue)
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .onAppear {
            if let service = service {
                bm.discoverCharecteristicsFor(service: service)
            }
        }
        .navigationTitle("Charecteristics")
//        .navigationTitle("Charecteristics")
    }
}

