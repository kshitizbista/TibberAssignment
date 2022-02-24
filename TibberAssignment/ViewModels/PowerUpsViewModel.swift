//
//  PowerUpsViewModel.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-24.
//

import Foundation
import Combine

class PowerUpsViewModel {
    func fetchData() -> AnyPublisher<[PowerUps], Error> {
        let urlRequest = GraphQLOperation.powerUpsOperationRequest()
        let response: AnyPublisher<Response<[PowerUps]>, Error> = APIClient.make(urlRequest, JSONDecoder())
        return response.map({$0.data.assignmentData}).eraseToAnyPublisher()
    }
    
    func sort(_ data: [PowerUps]) -> [PowerUps] {
        return data.sorted { lhs, rhs in
            lhs.title.lowercased() < rhs.title.lowercased()
        }
    }
}
