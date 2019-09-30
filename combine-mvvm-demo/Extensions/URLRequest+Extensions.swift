//
//  URLRequest+Extensions.swift
//  mvc-demo
//
//  Created by Niels Nørskov on 24/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation

enum HTTPMethod: String
{
	case GET
	case POST
	case PUT
	case DELETE
	case PATCH
}

extension URLRequest
{
	init?( for path: String, httpMethod: HTTPMethod, query: [String: String]? = nil, baseURL: URL )
	{
		// Generate URL relative to baseURL.
		let url = URL( fileURLWithPath: path, relativeTo: baseURL )

		// Add any paramters.
		var components = URLComponents( url: url, resolvingAgainstBaseURL: true )
		components?.queryItems = query?.map { URLQueryItem( name: $0.0, value: $0.1 ) }
        
        guard let quryURL = components?.url else { return nil }
        
		// Initialize with query URL.
		self.init( url: quryURL )

		// Set HTTP method.
		self.httpMethod = httpMethod.rawValue
	}
}
