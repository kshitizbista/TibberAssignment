//
//  ImageDownloader.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import Foundation
import Combine
import UIKit

class ImageDownloader {
    
    static func download(url: String) -> AnyPublisher<UIImage, AppError> {
        guard let url = URL(string: url) else {
            return Fail(error: AppError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw AppError.statusCode
                }
                return response.data
            }
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw AppError.invalidImage
                }
                return image
            }
            .mapError({ AppError.map($0)})
            .eraseToAnyPublisher()
    }
}
