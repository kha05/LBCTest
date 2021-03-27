//
//  ItemJSON.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

struct ItemJSON: Decodable {
    let id: Int64?
    let categoryId: Int64?
    let title: String?
    let description: String?
    let price: Double?
    let imagesUrl: ImageUrlJSON?
    let creationDate: Date?
    let isUrgent: Bool?
}
