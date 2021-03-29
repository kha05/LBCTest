//
//  CategoryService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol CategoryServiceRepresentable {
    func fetchCategories(completion: ((Result<[Category], Error>) -> Void)?)
}

final class CategoryService: CategoryServiceRepresentable {
    private let remote: WebServiceRepresentable
    
    private lazy var jsonDecoder: JSONDecoder = {
       let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(factory: ServiceFactory) {
        self.remote = factory.webService
    }
    
    func fetchCategories(completion: ((Result<[Category], Error>) -> Void)?) {
        remote.execute(API.fetchCategories().request?.url) { [jsonDecoder] (result) in
            switch result {
            case .success(let data):
                do {
                    let categoriesJson = try jsonDecoder.decode([CategorieJSON].self, from: data)
                    
                    let categories = categoriesJson.compactMap({ Category.toEntity(json: $0) })
                    completion?(.success(categories))
                    
                } catch {
                    completion?(.failure(APIError.invalidData(error)))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
