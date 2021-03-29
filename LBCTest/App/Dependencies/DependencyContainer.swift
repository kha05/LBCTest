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
    internal lazy var dateFormatter: DateManagerRepresentable = DateManager()
}

extension DependencyContainer: ViewControllerFactory {
    func makeItemsViewController(viewModel: ItemsViewModelRepresentable) -> ItemsViewController {
        return ItemsViewController(viewModel: viewModel)
    }
    
    func makeItemDetailViewController(viewModel: ItemDetailViewModelRepresentable) -> ItemDetailViewController {
        return ItemDetailViewController(viewModel: viewModel)
    }
}

extension DependencyContainer: ViewModelFactory {
    func makeItemsViewModel() -> ItemsViewModelRepresentable {
        return ItemsViewModel(factory: self)
    }
    
    func makeItemDetailViewModel(item: Item, categoryName: String) -> ItemDetailViewModelRepresentable {
        return ItemDetailViewModel(item: item, categoryName: categoryName, factory: self)
    }
}

extension DependencyContainer: ServiceFactory {}
