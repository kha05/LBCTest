//
//  ItemsViewModelTests.swift
//  LBCTestTests
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

import XCTest
@testable import LBCTest

class ItemsViewModelTests: EnvironmentMock {
    var synchronizationServiceMock: SynchronizationServiceMock!
    var imageServiceMock: ImageServiceMock!
    var viewModel: ItemsViewModelRepresentable!
    var coordinatorMock: ItemsCoordinatorMock!
    
    override func setUp() {
        super.setUp()
        self.viewModel = factoryMock.makeItemsViewModel()
        self.synchronizationServiceMock = (factoryMock.synchronizationService as! SynchronizationServiceMock)
        self.imageServiceMock = (factoryMock.imageService as! ImageServiceMock)
        self.coordinatorMock = ItemsCoordinatorMock()
        self.viewModel.coordinatorDelegate = coordinatorMock
    }
    
    func test_number_of_items_WHEN_no_item_SHOULD_return_0() {
        // GIVEN
        self.synchronizationServiceMock.items = []
        
        // THEN
        XCTAssertEqual(viewModel.itemsNumber, 0)
    }
    
    func test_number_of_items_WHEN_only_1_item_SHOULD_return_1() {
        // GIVEN
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "", imageThumbnailUrl: "", isUrgent: false)]
        
        // WHEN
        viewModel.synchronize()
        
        // THEN
        XCTAssertEqual(viewModel.itemsNumber, 1)
    }
    
    func test_image_item_WHEN_index_is_two_SHOULD_return_right_image() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch image")
        
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        
        let expectedImage = UIImage(named: "emptyPlaceholder")
        imageServiceMock.image = expectedImage
        
        var result: UIImage?
        
        // WHEN
        viewModel.synchronize()
        viewModel.itemImage(at: IndexPath(row: 0, section: 0)) { (image) in
            result = image
            expectaction.fulfill()
        }
        
        wait(for: [expectaction], timeout: 5)
        
        // THEN
        XCTAssertEqual(result, expectedImage)
    }
    
    func test_title_item_WHEN_index_is_0_SHOULD_return_right_title() {
        // GIVEN
        
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.itemTitle(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertEqual(result, "Test")
    }
    
    func test_title_item_WHEN_index_is_one_SHOULD_return_empty() {
        // GIVEN
        
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.itemTitle(at: IndexPath(row: 1, section: 0))
        
        // THEN
        XCTAssertEqual(result, "")
    }
    
    func test_category_item_WHEN_index_is_0_SHOULD_return_category() {
        // GIVEN
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        self.synchronizationServiceMock.categories = [LBCTest.Category(id: 0, name: "TestCategory")]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.itemCategory(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertEqual(result, "TestCategory")
    }
    
    func test_Category_item_WHEN_index_is_1_SHOULD_return_empty() {
        // GIVEN
        
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        self.synchronizationServiceMock.categories = [LBCTest.Category(id: 0, name: "TestCategory")]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.itemCategory(at: IndexPath(row: 1, section: 0))
        
        // THEN
        XCTAssertEqual(result, nil)
    }
    
    func test_price_item_WHEN_index_is_0_SHOULD_return_price_formatted() {
        // GIVEN
        
        self.synchronizationServiceMock.items = [Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.one, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.itemPrice(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertEqual(result, "1\u{00a0}€")
    }
    
    func test_items_WHEN_one_items_is_available_SHOULD_return_one_items() {
        // GIVEN
        let item1 = Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.one, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)
        self.synchronizationServiceMock.items = [item1]
        
        // WHEN
        viewModel.synchronize()
        let result = viewModel.item(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertEqual(result, item1)
        XCTAssertEqual(viewModel.itemsNumber, 1)
    }
    
    func test_items_WHEN_two_items_is_available_SHOULD_return_two_items() {
        // GIVEN
        let item1 = Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.one, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)
        let item2 = Item(id: 1, categoryId: 0, title: "Bonjour", description: "", price: NSDecimalNumber.zero, createdAt: Date(), imageSmallUrl: "small", imageThumbnailUrl: "thumbnail", isUrgent: false)
        self.synchronizationServiceMock.items = [item1, item2]
        self.synchronizationServiceMock.categories = [LBCTest.Category(id: 0, name: "TestCategory")]
        
        // WHEN
        viewModel.synchronize()
        let result1 = viewModel.item(at: IndexPath(row: 0, section: 0))
        let result2 = viewModel.item(at: IndexPath(row: 1, section: 0))
        
        // THEN
        XCTAssertEqual(result1, item1)
        XCTAssertEqual(result2, item2)
        XCTAssertEqual(viewModel.itemsNumber, 2)
    }
    
    func test_did_tap_item_at_index_SHOULD_call_coordinator() {
        // GIVEN
        let item1 = Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.one, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)
        self.synchronizationServiceMock.items = [item1]
        self.synchronizationServiceMock.categories = [LBCTest.Category(id: 0, name: "TestCategory")]
        
        // WHEN
        viewModel.synchronize()
        viewModel.tapItem(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertTrue(coordinatorMock.didTapItemCalled)
    }
    
    func test_did_tap_item_at_index_out_of_bound_SHOULD_NOT_call_coordinator() {
        // GIVEN
        let item1 = Item(id: 0, categoryId: 0, title: "Test", description: "", price: NSDecimalNumber.one, createdAt: Date(), imageSmallUrl: "testSmall", imageThumbnailUrl: "testThumbnail", isUrgent: false)
        self.synchronizationServiceMock.items = [item1]
        
        // WHEN
        viewModel.synchronize()
        viewModel.tapItem(at: IndexPath(row: 1, section: 0))
        
        // THEN
        XCTAssertFalse(coordinatorMock.didTapItemCalled)
    }
}
