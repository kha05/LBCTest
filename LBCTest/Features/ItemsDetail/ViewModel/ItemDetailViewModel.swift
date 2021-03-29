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
    var itemPrice: String { get }
    var isUrgentItem: Bool { get }
    var itemDate: String { get }
    
    func itemImage(completion: ((UIImage?) -> Void)?)
}

final class ItemDetailViewModel: ItemDetailViewModelRepresentable {
    private let item: Item
    private let categoryName: String
    
    private let itemService: ItemServiceRepresentable
    private let imageService: ImagesServiceRepresentable
    private let dateFormatter: DateManagerRepresentable
    
    init(item: Item, categoryName: String, factory: ServiceFactory) {
        self.item = item
        self.categoryName = categoryName
        self.itemService = factory.itemsService
        self.imageService = factory.imageService
        self.dateFormatter = factory.dateFormatter
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
    
    var itemPrice: String {
        return String("\(item.price) €")
    }
    
    var isUrgentItem: Bool {
        return item.isUrgent
    }
    
    var itemDate: String {
        let date = dateFormatter.formatDateToString(date: item.createdAt)
        return "Publié le \(date)"
    }
    
    func itemImage(completion: ((UIImage?) -> Void)?) {
        imageService.fetchImage(from: item.imageThumbnailUrl) { (result) in
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
