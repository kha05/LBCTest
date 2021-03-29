//
//  DependencyContainer.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//#imageLiteral(resourceName: "icons8-arrow-up-50.png")

import Foundation

typealias Factory = ViewControllerFactory & ServiceFactory & ViewModelFactory

final class DependencyContainer {
    internal lazy var webService: WebServiceRepresentable = WebService()
    
    internal lazy var itemsService: ItemServiceRepresentable = ItemService(factory: self)
    internal lazy var categoriesService: CategoryServiceRepresentable = CategoryService(factory: self)
    internal lazy var synchronizationService: SynchronizationServiceRepresentable = SynchronizationService(factory: self)
    internal lazy var imageService: ImagesServiceRepresentable = ImagesService(factory: self)
    
    internal lazy var imageCache: ImageCacheRepresentable = ImageCache()
}

extension DependencyContainer: ViewControllerFactory {
    func makeItemsViewController() -> ItemsViewController {
        return ItemsViewController(factory: self)
    }
}

extension DependencyContainer: ViewModelFactory {
    func makeItemsViewModel() -> ItemsViewModelRepresentable {
        return ItemsViewModel(factory: self)
    }
}

extension DependencyContainer: ServiceFactory {}
