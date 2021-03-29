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
    func execute(_ url: URL?, result completion: @escaping (Result<Data, Error>) -> Void)
    func cancel(_ url: URL?)
}

class WebService: WebServiceRepresentable {
    func execute(_ url: URL?, result completion: @escaping (Result<Data, Error>) -> Void) {
        guard let apiUrl = url else {
            return completion(.failure(APIError.invalidUrl))
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, response , error in
            
            guard let dataFetched = data else {
                return completion(.failure(APIError.invalidData(error)))
            }
            completion(.success(dataFetched))
        }
        
        task.resume()
    }
    
    func cancel(_ url: URL?) {
        guard let apiUrl = url else { return }
        URLSession.shared.dataTask(with: apiUrl).cancel()
    }
}
