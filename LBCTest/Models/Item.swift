//
//  Item.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

struct Item: Equatable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: NSDecimalNumber
    let createdAt: Date
    let imageSmallUrl: String?
    let imageThumbnailUrl: String?
    let isUrgent: Bool
}

extension Item {
    static func toEntity(json: ItemJSON) -> Item? {
        guard let id = json.id,
              let categoryId = json.categoryId,
              let price = json.price
        else { return nil }
        
        return Item(id: Int(id),
                    categoryId: Int(categoryId),
                    title: json.title ?? "",
                    description: json.description ?? "",
                    price: NSDecimalNumber(value: price),
                    createdAt: json.creationDate ?? Date(),
                    imageSmallUrl: json.imagesUrl?.small,
                    imageThumbnailUrl: json.imagesUrl?.thumb,
                    isUrgent: json.isUrgent ?? false)
    }
}
