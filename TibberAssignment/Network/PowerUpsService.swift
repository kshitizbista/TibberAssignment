//
//  PowerUpsAPI.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation
import Combine

struct PowerUpsService {
    
    private let api = "https://app.tibber.com/v4/gql"
    
    func fetchData(payload: Payload) -> AnyPublisher<[PowerUps], Error> {
        let url = URL(string: api)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)
        let response: AnyPublisher<Response<[PowerUps]>, Error> = APIClient.make(request, JSONDecoder())
        return response.map({$0.data.assignmentData}).eraseToAnyPublisher()
    }
}
