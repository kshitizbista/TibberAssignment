//
//  TibberAssignmentTests.swift
//  TibberAssignmentTests
//
//  Created by Kshitiz Bista on 2022-02-24.
//

import XCTest
import Combine
@testable import TibberAssignment

class MockAPIClient: Requestable {
    func make<T>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<T, Error> where T : Decodable {
        let data = Response.Data(assignmentData: MockAPIClient.getPowerUpsData())
        let response = Response(data: data)
        return Just(response as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    static func getPowerUpsData() -> [PowerUps] {
        let powerUps1 = PowerUps(title: "Device 1",
                                 description: "This is test device 1",
                                 longDescription: "Device 1 is being used for testing purpose",
                                 connected: true,
                                 storeUrl: "",
                                 imageUrl: "")
        let powerUps2 = PowerUps(title: "Device 2",
                                 description: "This is test device 2",
                                 longDescription: "Device 2 is being used for testing purpose",
                                 connected: false,
                                 storeUrl: "",
                                 imageUrl: "")
        let powerUps3 = PowerUps(title: "Device 3",
                                 description: "This is test device 3",
                                 longDescription: "Device 3 is being used for testing purpose",
                                 connected: true,
                                 storeUrl: "",
                                 imageUrl: "")
        return [powerUps1, powerUps2, powerUps3]
    }
}

class MockFailureAPIClient: Requestable {
    func make<T>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<T, Error> where T : Decodable {
        return Fail(error: APIError.statusCode(400))
            .eraseToAnyPublisher()
    }
}

class PowerUpsTests: XCTestCase {
    
    var sut: PowerUpsViewModel!
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellable.removeAll()
        try super.tearDownWithError()
    }
    
    func testAPICallReturnResponse() throws {
        sut = PowerUpsViewModel(apiClient: MockAPIClient())
        let expectedResponse = MockAPIClient.getPowerUpsData()
        let expectation = XCTestExpectation(description: "PowerUps Fetched")
        sut
            .fetchData()
            .sink(receiveCompletion: { _ in }) { response in
                XCTAssertEqual(response.count, expectedResponse.count)
                XCTAssertEqual(response[0].title, expectedResponse[0].title)
                XCTAssertEqual(response.last?.title, expectedResponse.last?.title)
                expectation.fulfill()
            }.store(in: &cancellable)
        wait(for: [expectation], timeout: 3)
    }
    
    func testAPICallReturnFailureStatus() throws {
        sut = PowerUpsViewModel(apiClient: MockFailureAPIClient())
        sut.fetchData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    guard case APIError.statusCode(let value) = error else {
                        return XCTFail()
                    }
                    XCTAssertEqual(value, 400)
                }
            }, receiveValue: { _ in})
            .store(in: &cancellable)
    }
}
