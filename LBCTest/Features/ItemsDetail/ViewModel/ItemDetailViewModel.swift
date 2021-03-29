//
//  ItemDetailViewModel.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

protocol ItemDetailViewModelRepresentable {
    var itemTitle: String { get }
    var itemDescription: String { get }
    var itemCategory: String { get }
    var itemPrice: String? { get }
    var isUrgentItem: Bool { get }
    var itemDate: String { get }
    
    func itemImage(completion: ((UIImage?) -> Void)?)
}

final class ItemDetailViewModel: ItemDetailViewModelRepresentable {
    private let item: Item
    private let categoryName: String
    
    private let factory: ServiceFactory & HelperFactory
    
    init(item: Item, categoryName: String, factory: ServiceFactory & HelperFactory) {
        self.item = item
        self.categoryName = categoryName
        self.factory = factory
    }
    
    var itemTitle: String {
        return item.title
    }
    
    var itemDescription: String {
        return item.description
    }
    
    var itemCategory: String {
        return categoryName
    }
    
    var itemPrice: String? {
        return factory.currencyFormatter.formatAmountToString(amount: item.price)
    }
    
    var isUrgentItem: Bool {
        return item.isUrgent
    }
    
    var itemDate: String {
        let date = factory.dateFormatter.formatDateToString(date: item.createdAt)
        return "Publié le \(date)"
    }
    
    func itemImage(completion: ((UIImage?) -> Void)?) {
        factory.imageService.fetchImage(from: item.imageThumbnailUrl) { (result) in
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
}
