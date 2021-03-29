//
//  DependencyContainer.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

typealias Factory = ViewControllerFactory & ServiceFactory & ViewControllerFactory

final class DependencyContainer {
    internal lazy var webService: WebServiceRepresentable = WebService()
    
    internal lazy var itemsService: ItemServiceRepresentable = ItemService(factory: self)
}

extension DependencyContainer: ViewControllerFactory {}

extension DependencyContainer: ViewModelFactory {}

extension DependencyContainer: ServiceFactory {}
