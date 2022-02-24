//
//  APIError.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation

enum APIError: Error {
    case statusCode(Int)
    case invalidResponse
    case invalidImage
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(error)
    }
    
    var localizedDescription: String {
        switch self {
        case .statusCode(let code):
            return "Request Failed with status code: \(code)"
        case .invalidResponse:
            return "Failed to fetch data from server"
        case .invalidImage:
            return "Invalid image url"
        case .invalidURL:
            return "Invalid url"
        case .other(let error):
            return "Error: \(error)"
        }
    }
}
