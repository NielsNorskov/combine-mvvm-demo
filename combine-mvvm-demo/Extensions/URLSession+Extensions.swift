//
//  URLSession+Extensionsx.swift
//  combine-mvvm-demo
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
    func fetchJSON<T:Codable>(for resource: Resource<T>) -> AnyPublisher<T, Error>
    {
        return dataTaskPublisher(for: resource.request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchImage(for url: URL, placeholder: UIImage? = nil) -> AnyPublisher<UIImage?, Never>
    {
        return dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw API.APIError.invalidResponse
                }
                return image
            }
            .replaceError(with: placeholder)
            .eraseToAnyPublisher()
    }
}
