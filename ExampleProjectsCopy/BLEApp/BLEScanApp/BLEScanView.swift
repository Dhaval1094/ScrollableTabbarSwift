//
//  ContentView.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 16/06/23.
//

import SwiftUI

struct BLEScanView: View {
    @StateObject var bm = BLEManager.shared
    @State private var isAnimating = true
    @State private var isShowingServicesView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if bm.state == .connecting {
                    Text("Connecting...")
                    Text("to \(bm.peripheralName)")
                    ActivityIndicator(shouldAnimate: self.$isAnimating)
                } else {
                    List(bm.arrPeripherals, id: \.self) { peripheral in
                        HStack {
                            if peripheral.state == .connected {
                                VStack(alignment: .leading) {
                                    Text(
                                        peripheral.name ?? peripheral.identifier.uuidString
                                    )
                                    .foregroundColor(Color.red)
                                    HStack {
                                        Button {
                                            bm.disconnect(peripheral: peripheral)
                                        } label: {
                                            Text("Disconnect")
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 100, height: 40)
                                        .background(.red)
                                        .buttonStyle(.borderless)
                                        Button {
                                             isShowingServicesView = true
                                        } label: {
                                            Text("Services")
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 100, height: 40)
                                        .background(.blue)
                                        .buttonStyle(.borderless)
                                    }
                                }
                                if isShowingServicesView {
                                    NavigationLink(destination: BLEServicesView(), isActive: $isShowingServicesView) {
                                        EmptyView()
                                    }
                                }
                            } else {
                                Text(
                                    peripheral.name ?? peripheral.identifier.uuidString
                                )
                                .onTapGesture {
                                    bm.updateState(peripheral: peripheral)
                                }
                            }
                        }
                        .listRowBackground(Color(UIColor.clear))
                    }
                }
            }
            .padding()
            .onAppear {
                bm.startScan()
            }
            .navigationTitle("Peripherals")
        }
    }
}
