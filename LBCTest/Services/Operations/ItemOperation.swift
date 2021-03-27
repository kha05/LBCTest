//
//  ItemOperation.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

final class ItemOperation: AsynchronousOperation {
    private let itemService: ItemServiceRepresentable
    private(set) var itemsFetched: [Item]?
    private(set) var error: Error?
    
    init(factory: ServiceFactory) {
        self.itemService = factory.itemsService
    }
    
    override func main() {
        itemService.fetchItems { [weak self] (result) in
            switch result {
            case .success(let items):
                self?.itemsFetched = items
            case .failure(let error):
                self?.error = error
            }
            
            self?.state = .isFinished
        }
    }
}
