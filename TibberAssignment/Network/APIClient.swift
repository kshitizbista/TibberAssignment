//
//  APIClient.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-24.
//

import Foundation
import Combine

protocol Requestable {
    static func make<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

struct APIClient: Requestable {
    private init () {}
    static func make<T>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<T, Error> where T : Decodable {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { response in
                guard let httpURLResponse = response.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                if httpURLResponse.statusCode == 200 {
                    return response.data
                }
                else {
                    throw APIError.statusCode(httpURLResponse.statusCode)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({APIError.map($0)})
            .eraseToAnyPublisher()
    }
}

struct GraphQLOperation {
    static func powerUpsOperationRequest() -> URLRequest {
        let api = "https://app.tibber.com/v4/gql"
        let GraphQLQuery =
            """
            {
                assignmentData {
                    title
                    description
                    longDescription
                    connected
                    storeUrl
                    imageUrl
                }
            }
            """
        let payload = Payload(query: GraphQLQuery)
        let url = URL(string: api)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)
        return request
    }
}
