//
//  PowerUps.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation

struct PowerUps: Decodable, Hashable {
    let title: String
    let description: String
    let longDescription: String
    let connected: Bool
    let storeUrl: String
    let imageUrl: String
}

