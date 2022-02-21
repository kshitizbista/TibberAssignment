//
//  Response.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    struct Data: Decodable {
        let assignmentData: T
    }
    let data: Data
}
