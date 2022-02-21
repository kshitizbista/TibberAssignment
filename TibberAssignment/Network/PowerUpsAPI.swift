//
//  PowerUpsAPI.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation
import Combine

class PowerUpsAPI {
    private static let api = "https://app.tibber.com/v4/gql"
    
    static func fetchData(payload: Payload) -> AnyPublisher<[PowerUps], AppError> {
        let url = URL(string: api)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw AppError.statusCode
                }
                return response.data
            }
            .decode(type: Response<[PowerUps]>.self, decoder: JSONDecoder())
            .map({$0.data.assignmentData})
            .mapError({AppError.map($0)})
            .eraseToAnyPublisher()
    }
}
