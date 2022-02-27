//
//  PowerUpsNetworkTests.swift
//  TibberAssignmentTests
//
//  Created by Kshitiz Bista on 2022-02-25.
//

import XCTest
import Combine
@testable import TibberAssignment

class PowerUpsNetworkTests: XCTestCase {
    
    var sut: PowerUpsViewModel!
    let networkMonitor = NetworkMonitor.shared
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PowerUpsViewModel(apiClient: APIClient())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellable.removeAll()
        try super.tearDownWithError()
    }
    
    func testValidAPICallGetsData() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        let expectation = XCTestExpectation(description: "Powerups data fetched")
        
        sut.fetchData()
            .sink(receiveCompletion: { _ in }) { response in
                XCTAssertTrue(!response.isEmpty)
                expectation.fulfill()
            }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
        
    }
    
}
