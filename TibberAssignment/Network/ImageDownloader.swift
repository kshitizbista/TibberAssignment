//
//  ImageDownloader.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation
import Combine
import UIKit

protocol ImageRequestable {
    static func download(url: String) -> AnyPublisher<UIImage, Error>
}

class ImageDownloader: ImageRequestable  {
    static func download(url: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard let httpURLResponse = response.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                if httpURLResponse.statusCode == 200 {
                    return response.data
                } else {
                    throw APIError.statusCode(httpURLResponse.statusCode)
                }
            }
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw APIError.invalidImage
                }
                return image
            }
            .mapError({ APIError.map($0)})
            .eraseToAnyPublisher()
    }
}
