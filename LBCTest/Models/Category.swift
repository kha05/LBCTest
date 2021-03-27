//
//  Category.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

struct Category: Equatable {
    let id: Int
    let name: String
}

extension Category {
    static func toEntity(json: CategorieJSON) -> Category? {
        guard let id = json.id,
              let name = json.name
        else { return nil }
        
        return Category(id: Int(id), name: name)
    }
}
