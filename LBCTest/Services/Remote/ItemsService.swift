//
//  ItemsService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

import Foundation

protocol ItemServiceRepresentable {
    func insertItems(completion: ((Result<[Item], Error>) -> Void)?)
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
    
    func insertItems(completion: ((Result<[Item], Error>) -> Void)?) {
        remote.execute(API.fetchItems().request) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let itemsJson = try self.jsonDecoder.decode([ItemJSON].self, from: data)
                    
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
