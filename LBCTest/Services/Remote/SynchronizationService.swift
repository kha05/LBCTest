//
//  SynchronizationService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol SynchronizationServiceRepresentable {
    func synchronize(completion: ((Result<([Item],[Category]), Error>) -> Void)?)
}

final class SynchronizationService: SynchronizationServiceRepresentable {
    private let factory: ServiceFactory
    
    init(factory: ServiceFactory) {
        self.factory = factory
    }
    
    func synchronize(completion: ((Result<([Item],[Category]), Error>) -> Void)?) {
        let queue = OperationQueue()
        let itemOperation = ItemOperation(factory: factory)
        let categoryOperation = CategoryOperation(factory: factory)
        
        itemOperation.addDependency(categoryOperation)
        
        DispatchQueue.global(qos: .utility).async {
            queue.addOperations([categoryOperation, itemOperation], waitUntilFinished: true)
            
            guard let items = itemOperation.itemsFetched, let categories = categoryOperation.categoriesFetched else {
                
                if let itemError = itemOperation.error {
                    completion?(.failure(itemError))
                } else if let categoryError = categoryOperation.error {
                    completion?(.failure(categoryError))
                } else {
                    completion?(.failure(APIError.genericServerError))
                }
                return
            }
            completion?(.success((items, categories)))
        }
    }
}
