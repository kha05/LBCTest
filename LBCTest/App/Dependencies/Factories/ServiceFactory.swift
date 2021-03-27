//
//  ServiceFactory.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol ServiceFactory {
    var webService: WebServiceRepresentable { get }
    var itemsService: ItemServiceRepresentable { get }
}
