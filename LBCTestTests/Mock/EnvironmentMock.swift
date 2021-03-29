//
//  EnvironmentMock.swift
//  LBCTestTests
//
//  Created by Ha Kevin on 27/03/2021.
//

import XCTest

@testable import LBCTest

class EnvironmentMock: XCTestCase {
    var factoryMock: FactoryMock!

    override func setUp() {
        factoryMock = FactoryMock()
        super.setUp()
        
    }
}

class FactoryMock: Factory {
    lazy var categoriesService: CategoryServiceRepresentable = CategorieServiceMock()
    
    lazy var synchronizationService: SynchronizationServiceRepresentable = SynchronizationServiceMock()
    
    lazy var imageService: ImagesServiceRepresentable = ImageServiceMock()
    
    lazy var imageCache: ImageCacheRepresentable = ImageCacheMock()
    
    lazy var itemsService: ItemServiceRepresentable = ItemsServiceMock()
    
    lazy var webService: WebServiceRepresentable = WebServiceMock()
    
    lazy var dateFormatter: DateManagerRepresentable = DateManager()
    
    lazy var currencyFormatter: CurrencyFormatterRepresentable = CurrencyFormatter()

    func makeItemsViewModel() -> ItemsViewModelRepresentable {
        return ItemsViewModel(factory: self)
    }
    
    func makeItemDetailViewModel(item: Item, categoryName: String) -> ItemDetailViewModelRepresentable {
        return ItemDetailViewModel(item: item, categoryName: categoryName, factory: self)
    }
    
    func makeItemsViewController(viewModel: ItemsViewModelRepresentable) -> ItemsViewController {
        return ItemsViewController(viewModel: viewModel)
    }
    
    func makeItemDetailViewController(viewModel: ItemDetailViewModelRepresentable) -> ItemDetailViewController {
        return ItemDetailViewController(viewModel: viewModel)
    }
}

class WebServiceMock: WebServiceRepresentable {
    var result: Result<Data, Error> = .success(Data())
    
    func execute(_ url: URL?, result completion: @escaping (Result<Data, Error>) -> Void) {
        completion(result)
    }
    
    func execute(_ request: URLRequest?, result completion: @escaping (Result<Data, Error>) -> Void) {
        completion(result)
    }
}

class ItemsServiceMock: ItemServiceRepresentable {
    var items = [Item]()
    
    func fetchItems(completion: ((Result<[Item], Error>) -> Void)?) {
        completion?(.success(items))
    }
}

class CategorieServiceMock: CategoryServiceRepresentable {
    
    var categories = [LBCTest.Category]()
    
    
    func fetchCategories(completion: ((Result<[LBCTest.Category], Error>) -> Void)?) {
        completion?(.success(categories))
    }
}

class ImageServiceMock: ImagesServiceRepresentable {
    var image: UIImage? = nil
    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        completion(.success(image))
    }
    
    func prefetchImages(items: [Item], indexPaths: [IndexPath], completion: ((Result<UIImage, Error>) -> Void)?) {
        
    }
    
    func cancelPrefetchImages(indexPaths: [IndexPath]) {
        
    }
}

class ImageCacheMock: ImageCacheRepresentable {
    var image: UIImage? = nil
    
    func insertImage(image: UIImage, for url: String) {
        
    }
    
    func fetchImage(url: String) -> UIImage? {
        return image
    }
    
    
}

class SynchronizationServiceMock: SynchronizationServiceRepresentable {
    var items = [Item]()
    var categories = [LBCTest.Category]()
    
    func synchronize(completion: ((Result<([Item], [LBCTest.Category]), Error>) -> Void)?) {
        completion?(.success((items, categories)))
    }
}

class ItemsCoordinatorMock: ItemsCoordinatorDelegate {
    var didTapItemCalled = false
    
    func didTapItem(item: Item, categoryName: String) {
        didTapItemCalled = true
    }
}
