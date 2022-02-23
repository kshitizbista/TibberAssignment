//
//  PowerUps.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation

struct PowerUps: Decodable, Hashable {
    var id = UUID()
    let title: String
    let description: String
    let longDescription: String
    var connected: Bool
    let storeUrl: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
          case title, description, longDescription, connected, storeUrl, imageUrl
      }
}

extension PowerUps {
    private static let GraphQLQuery =
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
    
    static let payload = Payload(query: GraphQLQuery)
}

