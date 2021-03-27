//
//  ItemsService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol ItemServiceRepresentable {
    func fetchItems(completion: ((Result<[Item], Error>) -> Void)?)
}

final class ItemService: ItemServiceRepresentable {
    private let remote: WebServiceRepresentable
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(factory: ServiceFactory) {
        self.remote = factory.webService
    }
    
    func fetchItems(completion: ((Result<[Item], Error>) -> Void)?) {
        remote.execute(API.fetchItems().request) { [jsonDecoder] (result) in
            switch result {
            case .success(let data):
                do {
                    let itemsJson = try jsonDecoder.decode([ItemJSON].self, from: data)
                    
                    let items = itemsJson.compactMap({ Item.toEntity(json: $0) })
                    completion?(.success(items))
                    
                } catch {
                    completion?(.failure(APIError.invalidData(error)))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
