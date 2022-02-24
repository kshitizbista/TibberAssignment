//
//  PowerUpsAPITests.swift
//  TibberAssignmentTests
//
//  Created by Kshitiz Bista on 2022-02-24.
//

import XCTest
@testable import TibberAssignment

class PowerUpsAPITests: XCTestCase {
    
    var sut: PowerUpsAPI!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PowerUpsAPI()
    }

    override func tearDownWithError() throws {
        sut = nil
        try tearDownWithError()
    }

    func testValidApiCallGetsHTTPStatusCode200() throws {
        
    }

}
