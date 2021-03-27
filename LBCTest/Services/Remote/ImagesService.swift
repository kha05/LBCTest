//
//  ImagesService.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

protocol ImagesServiceRepresentable {
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

final class ImagesService: ImagesServiceRepresentable {
    private let factory: ServiceFactory
    
    private lazy var operationQueue: OperationQueue = OperationQueue()
    private var loadingOperations: [IndexPath: FetchImageOperation] = [:]
    
    init(factory: ServiceFactory) {
        self.factory = factory
    }
    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let url = URL(string: urlString)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = self.factory.imageCache.fetchImage(url: urlString) {
                completion(.success(image))
            } else {
                self.factory.webService.execute(url) { [weak self] result in
                    guard let data = try? result.get(),
                          let image = UIImage(data: data) else {
                        completion(.failure(APIError.failedFetchImage))
                        return
                    }
                    
                    self?.factory.imageCache.insertImage(image: image, for: urlString)
                    completion(.success(image))
                }
            }
        }
    }
    
    func prefetchImage(items: [Item], indexPaths: [IndexPath], completion: ((Result<UIImage, Error>) -> Void)?) {
        for index in indexPaths {
            guard loadingOperations[index] == nil else { return }
            let operation = FetchImageOperation(imageUrl: items[index.row].imageSmallUrl, factory: factory)
            loadingOperations[index] = operation
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.operationQueue.addOperation(operation)
            }
        }
    }
    
    func cancelPrefetchImage(indexPaths: [IndexPath]) {
        for index in indexPaths {
            if let operation = loadingOperations[index] {
                operation.cancel()
                loadingOperations.removeValue(forKey: index)
            }
        }
    }
}
