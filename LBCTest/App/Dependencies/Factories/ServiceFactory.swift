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
    var categoriesService: CategoryServiceRepresentable { get }
    var synchronizationService: SynchronizationServiceRepresentable { get }
    var imageService: ImagesServiceRepresentable { get }
}
