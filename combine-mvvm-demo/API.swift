//
//  API.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 24/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation

class API
{
    enum APIError: Error
    {
        /// Network error from URLSession.
        case networkError(Error)
        
        /// HTTP status error.
        case httpStatusError(statusCode: Int)
        
        /// Invalid data returned by server.
        case invalidResponse
    }
}
