//
//  APIError.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation

enum APIError: Error {
    case statusCode
    case decoding
    case invalidImage
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(error)
    }
}
