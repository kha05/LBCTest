//
//  WebService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidUrl
    case invalidData(_ error: Error?)
    case failedFetchImage
    case genericServerError
}

protocol WebServiceRepresentable: AnyObject {
    func execute(_ request: URLRequest?, result completion: @escaping (Result<Data, Error>) -> Void)
}

class WebService: WebServiceRepresentable {
    func execute(_ request: URLRequest?, result completion: @escaping (Result<Data, Error>) -> Void) {
        guard let apiRequest = request else {
            return completion(.failure(APIError.invalidRequest))
        }
        
        let task = URLSession.shared.dataTask(with: apiRequest) { data, response , error in
            guard let dataFetched = data else {
                return completion(.failure(APIError.invalidData(error)))
            }
            completion(.success(dataFetched))
        }
        task.resume()
    }
}
