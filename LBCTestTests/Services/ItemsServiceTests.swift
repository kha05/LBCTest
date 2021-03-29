//
//  ItemsServiceTests.swift
//  LBCTestTests
//
//  Created by Ha Kevin on 29/03/2021.
//

import XCTest
@testable import LBCTest

class ItemsServiceTests: EnvironmentMock {
    var service: ItemServiceRepresentable!
    var webServiceMock: WebServiceMock!
    var dateFormatter: DateManagerRepresentable!
    
    override func setUp() {
        super.setUp()
        self.service = ItemService(factory: factoryMock)
        self.dateFormatter = factoryMock.dateFormatter
        self.webServiceMock = (factoryMock.webService as! WebServiceMock)
    }
    
    func test_error_WHEN_error_servor_SHOULD_return_failure() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch items")
        webServiceMock.result = .failure(APIError.genericServerError)
        
        // WHEN
        service.fetchItems { (result) in
            do {
                let _ = try result.get()
            } catch(let error) {
                // THEN
                XCTAssertEqual((error as? APIError)?.localizedDescription, APIError.genericServerError.localizedDescription)
            }
            
            expectaction.fulfill()
        }
        
        wait(for: [expectaction], timeout: 5)
    }
    
    func test_success_WHEN_servor_return_success_SHOULD_return_items() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch items")
        let json: [Any] = [["id": 1,
                                   "category_id": 4,
                                   "title":"Test",
                                   "description": "",
                                   "price": 140.00,
                                   "images_url": [
                                    "small":"testSmall",
                                    "thumb":"testThumbnail"
                                   ],
                                   "creation_date": "2019-11-05T15:56:59+0000",
                                   "is_urgent": false
        ]]
        
        let expectedItems = [Item(id: 1,
                                  categoryId: 4,
                                  title: "Test",
                                  description: "",
                                  price: NSDecimalNumber(value: 140.0),
                                  createdAt: dateFormatter.formatStringToDateIso8601(string: "2019-11-05T15:56:59+0000") ?? Date(),
                                  imageSmallUrl: "testSmall",
                                  imageThumbnailUrl: "testThumbnail",
                                  isUrgent: false)]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultItems = [Item]()
        
        // WHEN
        service.fetchItems { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let items):
                    resultItems = items
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultItems, expectedItems)
    }
    
    func test_empty_object_WHEN_servor_return_item_with_no_ID_SHOULD_return_nothing() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch items")
        let json: [Any] = [["id": "",
                                   "category_id": 4,
                                   "title":"Test",
                                   "description": "",
                                   "price": 140.00,
                                   "images_url": [
                                    "small":"testSmall",
                                    "thumb":"testThumbnail"
                                   ],
                                   "creation_date": "2019-11-05T15:56:59+0000",
                                   "is_urgent": false
        ]]
    
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultItems = [Item]()
        
        // WHEN
        service.fetchItems { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let items):
                    resultItems = items
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultItems, [])
    }
    
    func test_empty_object_WHEN_servor_return_item_with_no_catogry_ID_SHOULD_return_nothing() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch items")
        let json: [Any] = [["id": 1,
                                   "category_id": "",
                                   "title":"Test",
                                   "description": "",
                                   "price": 140.00,
                                   "images_url": [
                                    "small":"testSmall",
                                    "thumb":"testThumbnail"
                                   ],
                                   "creation_date": "2019-11-05T15:56:59+0000",
                                   "is_urgent": false
        ]]
    
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultItems = [Item]()
        
        // WHEN
        service.fetchItems { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let items):
                    resultItems = items
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultItems, [])
    }
    
    func test_empty_object_WHEN_servor_return_item_with_no_price_SHOULD_return_nothing() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch items")
        let json: [Any] = [["id": 1,
                                   "category_id": 4,
                                   "title":"Test",
                                   "description": "",
                                   "price": "",
                                   "images_url": [
                                    "small":"testSmall",
                                    "thumb":"testThumbnail"
                                   ],
                                   "creation_date": "2019-11-05T15:56:59+0000",
                                   "is_urgent": false
        ]]
    
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultItems = [Item]()
        
        // WHEN
        service.fetchItems { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let items):
                    resultItems = items
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultItems, [])
    }
}
