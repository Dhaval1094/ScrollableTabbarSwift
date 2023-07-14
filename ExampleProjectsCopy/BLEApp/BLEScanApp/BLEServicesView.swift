//
//  BLEDetailsView.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 19/06/23.
//

import SwiftUI
import CoreBluetooth

struct BLEServicesView: View {
    @StateObject var bm = BLEManager.shared
    @State private var isShowingCharecteristicsView = false
    @State private var selectedService: CBService?
    var body: some View {
        VStack {
            if bm.isDiscoverServices {
                if let services = bm.peripheral?.services {
                    List(services, id: \.self) { service in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(service.uuid.uuidString.count > 32 ? "Custom Service" : "\(service.uuid)")
                                    .font(.headline)
                                    .background(Color(uiColor: .lightGray))
                                    .padding(.bottom, 6)
                                Text(service.uuid.uuidString)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 6)
                                Text(service.isPrimary ? "PRIMARY SERVICE" : "SECONDARY SERVICE")
                            }
                            Spacer()
                            Button {
                                isShowingCharecteristicsView = true
                                selectedService = service
                            } label: {
                                Image("right_arrow")
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                            .buttonStyle(.borderless)
                        }
                        .listRowBackground(Color(UIColor.clear))
                    }
                }
            }
        }
        .onAppear {
            bm.discoverServices()
        }
        .navigationTitle("Services")
        if isShowingCharecteristicsView {
            NavigationLink(destination: BLECharecteristicsView(service: selectedService), isActive: $isShowingCharecteristicsView) {
                EmptyView()
            }
        }
    }
}
