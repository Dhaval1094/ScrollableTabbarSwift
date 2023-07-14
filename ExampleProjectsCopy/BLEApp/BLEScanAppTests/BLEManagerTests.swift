//
//  BLEManagerTests.swift
//  BLEScanDemoTests
//
//  Created by Dhaval Trivedi on 21/06/23.
//

import XCTest
@testable import BLEScanApp

final class BLEManagerTests: XCTestCase {
    
    let sut = BLEManager.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStartScan() {
        sut.startScan()
    }
    
    func testStopScan() {
        sut.stopScan()
    }
    
    func testInitialValues() {
        XCTAssertEqual(sut.arrPeripherals.count, 0, "The arrPeripherals should not contain peripherals before scan")
        XCTAssertFalse(sut.isDiscoverServices, "The initial value of isDiscoverServices should be false")
        XCTAssertFalse(sut.isDiscoverCharecteristics, "The initial value of isDiscoverCharecteristics should be false")
        XCTAssertFalse(sut.isShowCharecteristicDetails, "The initial value of isShowCharecteristicDetails should be false")
        XCTAssertEqual(sut.state, .disconnected, "The state should be disconnected at first time")
        XCTAssertNotNil(sut.charecteristicValue, "The charecteristics value should not nil")
    }
}
