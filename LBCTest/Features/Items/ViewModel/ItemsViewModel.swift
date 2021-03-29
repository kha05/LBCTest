//
//  ItemsViewModel.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

protocol ItemsViewModelRepresentable: AnyObject {
    var coordinatorDelegate: ItemsCoordinatorDelegate? { get set }
    var itemsNumber: Int { get }
    
    var reloadItems: (() -> Void)? { get set }
    var stopLoader: (() -> Void)? { get set }
    
    func item(at index: IndexPath) -> Item?
    func itemImage(at index: IndexPath, completion: ((UIImage?) -> Void)?)
    func itemTitle(at index: IndexPath) -> String
    func itemCategory(at index: IndexPath) -> String?
    func itemPrice(at index: IndexPath) -> String?
    func isUrgentItem(at index: IndexPath) -> Bool
    
    func tapItem(at index: IndexPath)
    func prefetchNextItemsImages(at indexPaths: [IndexPath])
    func cancelPrefetchNextItemsImages(at indexPaths: [IndexPath])
    
    func synchronize()
}

final class ItemsViewModel: ItemsViewModelRepresentable {
    weak var coordinatorDelegate: ItemsCoordinatorDelegate?
        
    private let factory: ServiceFactory & HelperFactory

    private var items: [Item] = []
    private var categories: [Category] = []
    
    init(factory: ServiceFactory & HelperFactory) {
        self.factory = factory
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
    
    func itemPrice(at index: IndexPath) -> String? {
        guard index.row < items.count else { return nil }
        return factory.currencyFormatter.formatAmountToString(amount: items[index.row].price)
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
        
        factory.imageService.fetchImage(from: items[index.row].imageSmallUrl) { (result) in
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
        factory.synchronizationService.synchronize { [weak self] (result) in
            switch result {
            case .success((let items, let categories)):
                self?.items = items
                self?.categories = categories
                
                DispatchQueue.main.async {
                    self?.reloadItems?()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.stopLoader?()
                }
            }
        }
    }
    
    func tapItem(at index: IndexPath) {
        guard index.row < items.count,
              let item = item(at: index),
              let category = itemCategory(at: index) else { return }
        
        coordinatorDelegate?.didTapItem(item: item, categoryName: category)
    }
    
    func prefetchNextItemsImages(at indexPaths: [IndexPath]) {
        factory.imageService.prefetchImages(items: items, indexPaths: indexPaths, completion: nil)
    }
    
    func cancelPrefetchNextItemsImages(at indexPaths: [IndexPath]) {
        factory.imageService.cancelPrefetchImages(indexPaths: indexPaths)
    }
}
