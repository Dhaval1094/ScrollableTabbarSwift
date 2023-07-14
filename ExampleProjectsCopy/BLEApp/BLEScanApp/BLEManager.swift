//
//  CBManager.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 16/06/23.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject {
    
    // MARK: Properties
    static let shared = BLEManager()
    var centralManager = CBCentralManager()
    var peripheral: CBPeripheral?
    @Published var isDiscoverServices = false
    @Published var isDiscoverCharecteristics = false
    @Published var arrPeripherals = [CBPeripheral]()
    @Published var state = Connection.disconnected
    @Published var charecteristicValue = ""
    @Published var isShowCharecteristicDetails = false
    enum Connection {
        case connected
        case disconnected
        case connecting
    }
    var peripheralName: String {
       return peripheral?.name ?? peripheral?.identifier.uuidString ?? ""
    }
    
    // MARK: Methods
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    func startScan() {
        centralManager.scanForPeripherals(withServices: nil)
    }
    func stopScan() {
        centralManager.stopScan()
    }
    func connect(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        state = .connecting
        centralManager.connect(peripheral)
        centralManager.stopScan()
    }
    func updateState(peripheral: CBPeripheral) {
        if peripheral.state != .connected {
            connect(peripheral: peripheral)
        }
    }
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    func discoverServices() {
        peripheral?.discoverServices(nil)
    }
    func discoverCharecteristicsFor(service: CBService) {
        peripheral?.discoverCharacteristics(nil, for: service)
    }
    func readValueFor(charecteristic: CBCharacteristic, value: Bool) {
        peripheral?.setNotifyValue(value, for: charecteristic)
        peripheral?.readValue(for: charecteristic)
    }
    // TODO: parse write value instead of static
    func writeValueFor(charecteristic: CBCharacteristic) {
        peripheral?.writeValue("He".data(using: .utf8)!, for: charecteristic, type: .withResponse)
    }
}

// MARK: CBCentralManager Delegates
extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
      if central.state == .poweredOn {
        // Bluetooth is ready to use
          startScan()
      } else {
        // Bluetooth is not available
      }
    }
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
      // A peripheral has been discovered
        let peripherals = arrPeripherals.filter {
            return $0.identifier == peripheral.identifier
        }
        if peripherals.count == 0 {
            // TO DO: Remove below if condition
            if peripheral.name == "GATEWAY" {
                arrPeripherals.append(peripheral)
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        state = .connected
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral.identifier == self.peripheral?.identifier {
            state = .disconnected
            self.peripheral = nil
        }
    }
}

// MARK: CBPeripheral Delegates
extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first else {
            return
        }
        self.peripheral = peripheral
        // peripheral.discoverCharacteristics(nil, for: service)
        isDiscoverServices = true        
        print("didDiscoverServices: \(service)")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("didDiscoverIncludedServicesFor")
    }
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheralDidUpdateName")
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices")
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValueFor: \(characteristic)")
        guard let error = error else {
            return
        }
        print(error)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristicsFor: \(service)")
        isDiscoverCharecteristics = true
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor \(characteristic.uuid) \n")
        guard let value = characteristic.value else {
            return
        }
        charecteristicValue = String(decoding: value, as: UTF8.self)
        print("**Value: \(charecteristicValue) \n")
        isShowCharecteristicDetails = true
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("didReadRSSI")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("didDiscoverDescriptorsFor: \(characteristic.uuid)")
    }
}
