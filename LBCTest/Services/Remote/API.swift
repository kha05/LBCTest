//
//  API.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

struct API {
    let httpMethod: HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]?
    
}

extension API {
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        return request
    }
    
    enum HTTPMethod: String {
        case GET     = "GET"
        case POST    = "POST"
        case PUT     = "PUT"
        case DELETE  = "DELETE"
    }
}

extension API {
    static func fetchItems() -> API {
        return API(
            httpMethod: .GET,
            path: "/leboncoin/paperclip/master/listing.json",
            queryItems: []
        )
    }
    
    static func fetchCategories() -> API {
        return API(
            httpMethod: .GET,
            path: "/leboncoin/paperclip/master/categories.json",
            queryItems: []
        )
    }
}
