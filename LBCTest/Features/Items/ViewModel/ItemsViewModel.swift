//
//  ItemsViewModel.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

protocol ItemsViewModelRepresentable: AnyObject {
    var itemsNumber: Int { get }
    
    var reloadItems: (() -> Void)? { get set }
    var stopLoader: (() -> Void)? { get set }
    
    func item(at index: IndexPath) -> Item?
    func itemImage(at index: IndexPath, completion: ((UIImage?) -> Void)?)
    func itemTitle(at index: IndexPath) -> String
    func itemCategory(at index: IndexPath) -> String?
    func itemPrice(at index: IndexPath) -> String
    func isUrgentItem(at index: IndexPath) -> Bool

    func prefetchNextItemsImages(at indexPaths: [IndexPath])
    func cancelPrefetchNextItemsImages(at indexPaths: [IndexPath])
    
    func synchronize()
}

final class ItemsViewModel: ItemsViewModelRepresentable {
    private let factoryService: ServiceFactory

    private var items: [Item] = []
    private var categories: [Category] = []
    
    init(factory: ServiceFactory & ViewModelFactory) {
        self.factoryService = factory
    }
    
    var reloadItems: (() -> Void)?
    var stopLoader: (() -> Void)?
    
    var itemsNumber: Int {
        return items.count
    }
    
    func item(at index: IndexPath) -> Item? {
        guard index.row < items.count else { return nil }
        return items[index.row]
    }
    
    func itemCategory(at index: IndexPath) -> String? {
        guard index.row < items.count else { return nil }
        return categories.first(where: { $0.id == items[index.row].categoryId })?.name
    }
    
    func itemPrice(at index: IndexPath) -> String {
        guard index.row < items.count else { return "" }
        return String("\(items[index.row].price) €")
    }
    
    func itemTitle(at index: IndexPath) -> String {
        guard index.row < items.count else { return "" }
        return items[index.row].title
    }

    func isUrgentItem(at index: IndexPath) -> Bool {
        guard index.row < items.count else { return false }
        return items[index.row].isUrgent
    }
    
    func itemImage(at index: IndexPath, completion: ((UIImage?) -> Void)?) {
        guard index.row < items.count else {
            completion?(UIImage(named: "emptyPlaceholder"))
            return
        }
        
        factoryService.imageService.fetchImage(from: items[index.row].imageSmallUrl) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    completion?(image)
                case .failure(_):
                    completion?(UIImage(named: "emptyPlaceholder"))

                    }
                }
            }
    }
    
    func synchronize() {
        factoryService.synchronizationService.synchronize { [weak self] (result) in
            switch result {
            case .success((let items, let categories)):
                self?.items = items
                self?.categories = categories
                
                DispatchQueue.main.async {
                    self?.reloadItems?()
                }
            case .failure(_):
                self?.stopLoader?()

            }
        }
    }
    
    func prefetchNextItemsImages(at indexPaths: [IndexPath]) {
        factoryService.imageService.prefetchImages(items: items, indexPaths: indexPaths, completion: nil)
    }
    
    func cancelPrefetchNextItemsImages(at indexPaths: [IndexPath]) {
        factoryService.imageService.cancelPrefetchImages(indexPaths: indexPaths)
    }
}
