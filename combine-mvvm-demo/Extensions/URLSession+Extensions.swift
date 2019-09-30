//
//  URLSession+Extensionsx.swift
//  mvc-demo
//
//  Created by Niels Nørskov on 24/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.

import Foundation
import Combine
import UIKit

struct Resource<T: Codable>
{
    let request: URLRequest
}

extension URLSession
{
    /// Fetch JSOM model from server.
    /// - Parameter resource: Resource<T> for Codable JSON model of type T.
    /// - Returns: AnyPublisher<T, Error>.
    func fetchJSON<T:Codable>(for resource: Resource<T>) -> AnyPublisher<T, Error>
    {
        return dataTaskPublisher(for: resource.request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Fetch image from server.
    /// - Parameter url: URL pointing to image resource.
    /// - Parameter placeholder: Placeholder image if image can't be downloaded.
    /// - Returns: AnyPublisher<UIImage?, Never>.
    func fetchImage(for url: URL, placeholder: UIImage? = nil) -> AnyPublisher<UIImage?, Never>
    {
        return dataTaskPublisher(for: url)
            .tryMap {data, response -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw API.APIError.invalidResponse
                }
                return image
            }
            .replaceError(with: placeholder)
            .eraseToAnyPublisher()
    }
}
