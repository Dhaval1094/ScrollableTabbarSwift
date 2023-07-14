//
//  CBManager.swift
//  BLEScanDemo
//
//  Created by Dhaval Trivedi on 16/06/23.
//

import Foundation
import CoreBluetooth

class ENVBluetoothManager: NSObject, ObservableObject {
    
    // MARK: Properties
    static let shared = ENVBluetoothManager()
    var centralManager = CBCentralManager()
    var peripheral: CBPeripheral!
    var service: CBService!
    var characteristic: CBCharacteristic!
    @Published var isFindData = false
    @Published var state = Connection.disconnected
    enum Connection {
        case connected
        case disconnected
        case connecting
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
//            isFindData = false
            connect(peripheral: peripheral)
        }
    }
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    func showStoredValues() {
        if let value = UserDefaults.standard.value(forKey: "char") as? Data {
            ENVCharacteristics.shared.parseSensorData(data: value)
            isFindData = true
        }
    }
}

// MARK: CBCentralManager Delegates
extension ENVBluetoothManager: CBCentralManagerDelegate {
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
        // TO DO: Remove below if condition
        if peripheral.name == ENVCharacteristics.shared.sensorName {
            connect(peripheral: peripheral)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        state = .connected
        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        state = .disconnected
    }
}

// MARK: CBPeripheral Delegates
extension ENVBluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let services = peripheral.services?.filter {
            return $0.uuid.uuidString == ENVCharacteristics.serviceUUID
        }
        guard let service = services?.first else {
            return
        }
        print("didDiscoverServices: \(service)")
        self.service = service
        self.peripheral = peripheral
        self.peripheral.discoverCharacteristics([CBUUID.init(string: ENVCharacteristics.characteristicUUID)], for: service)
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
        if let char = service.characteristics?.first {
            self.characteristic = char
            self.peripheral.setNotifyValue(true, for: characteristic)
            self.peripheral.readValue(for: characteristic)
        }
        print("didDiscoverCharacteristicsFor: \(service)")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor \(characteristic.uuid) \n")
        guard let value = characteristic.value else {
            return
        }
        UserDefaults.standard.set(value, forKey: "char")
        ENVCharacteristics.shared.parseSensorData(data: value)
        isFindData = true
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("didReadRSSI")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("didDiscoverDescriptorsFor: \(characteristic.uuid)")
    }
}
