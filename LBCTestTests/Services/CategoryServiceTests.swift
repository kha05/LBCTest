//
//  CategoryServiceTests.swift
//  LBCTestTests
//
//  Created by Ha Kevin on 29/03/2021.
//

import XCTest
@testable import LBCTest

class CategoryServiceTests: EnvironmentMock {
    var service: CategoryServiceRepresentable!
    var webServiceMock: WebServiceMock!
    
    override func setUp() {
        super.setUp()
        self.service = CategoryService(factory: factoryMock)
        self.webServiceMock = (factoryMock.webService as! WebServiceMock)
    }
 
    func test_error_WHEN_error_servor_SHOULD_return_failure() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch categories")
        webServiceMock.result = .failure(APIError.genericServerError)
        
        // WHEN
        service.fetchCategories { (result) in
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
    
    func test_success_WHEN_servor_return_success_SHOULD_return_categories() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch categories")
        let json: [Any] = [[
            "id": 1,
            "name": "Véhicule"
        ]]
        
        let expectedCategories = [LBCTest.Category(id: 1, name: "Véhicule")]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultCategories = [LBCTest.Category]()
        
        // WHEN
        service.fetchCategories { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let categories):
                    resultCategories = categories
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultCategories, expectedCategories)
    }
    
    func test_success_WHEN_servor_return_category_with_no_ID_SHOULD_return_nothing() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch categories")
        let json: [Any] = [[
            "id": "",
            "name": "Véhicule"
        ]]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultCategories = [LBCTest.Category]()
        
        // WHEN
        service.fetchCategories { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let categories):
                    resultCategories = categories
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultCategories, [])
    }
    
    func test_success_WHEN_servor_return_category_with_no_name_SHOULD_return_nothing() {
        // GIVEN
        let expectaction = XCTestExpectation(description: "fetch categories")
        let json: [Any] = [[
            "id": 1,
            "name": nil
        ]]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            webServiceMock.result = .success(data)
        } catch {
            XCTAssert(false)
        }
        
        var resultCategories = [LBCTest.Category]()
        
        // WHEN
        service.fetchCategories { (result) in
            expectaction.fulfill()
            switch result {
                case .success(let categories):
                    resultCategories = categories
                case .failure(_): break
            }
        }
        
        wait(for: [expectaction], timeout: 10)
        
        // THEN
        XCTAssertEqual(resultCategories, [])
    }
}
