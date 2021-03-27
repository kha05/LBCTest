//
//  CategoryOperation.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

final class CategoryOperation: AsynchronousOperation {
    private let categoryService: CategoryServiceRepresentable
    private(set) var categoriesFetched: [Category]?
    private(set) var error: Error?
    
    init(factory: ServiceFactory) {
        self.categoryService = factory.categoriesService
    }
    
    override func main() {
        categoryService.fetchCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.categoriesFetched = categories
            case .failure(let error):
                self?.error = error
            }
            self?.state = .isFinished
        }
    }
}
