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
    func cancelFetchImage(urlString: String)
    func prefetchImages(items: [Item], indexPaths: [IndexPath])
    func cancelPrefetchImages(indexPaths: [IndexPath])
}

final class ImagesService: ImagesServiceRepresentable {
    private let factory: ServiceFactory & HelperFactory
    
    private lazy var operationQueue: OperationQueue = OperationQueue()
    private var loadingOperations: [IndexPath: FetchImageOperation] = [:]
    
    init(factory: ServiceFactory & HelperFactory) {
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
    
    func cancelFetchImage(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            self.factory.webService.cancel(url)
        }
    }
    
    func prefetchImages(items: [Item], indexPaths: [IndexPath]) {
        indexPaths
            .filter({ loadingOperations[$0] == nil && $0.row < items.count })
            .forEach { (index) in
                let operation = FetchImageOperation(imageUrl: items[index.row].imageSmallUrl, factory: factory)
                loadingOperations[index] = operation
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.operationQueue.addOperation(operation)
                }
            }
    }
    
    func cancelPrefetchImages(indexPaths: [IndexPath]) {
        indexPaths.forEach { (index) in
            loadingOperations[index]?.cancel()
            loadingOperations.removeValue(forKey: index)
        }
    }
}
