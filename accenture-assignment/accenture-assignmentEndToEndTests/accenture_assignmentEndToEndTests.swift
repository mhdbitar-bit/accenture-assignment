//
//  accenture_assignmentEndToEndTests.swift
//  accenture-assignmentEndToEndTests
//
//  Created by Mohammad Bitar on 7/2/22.
//

@testable import accenture_assignment
import XCTest


class accenture_assignmentEndToEndTests: XCTestCase {
    
    func test_endToEndServerGETCategoriesResult_matchesFixedTestAccountData() {
        switch getCategoriesResult() {
        case let .success(categories)?:
            XCTAssertEqual(categories.count, 3, "Expected 3 items in the test account category")
            XCTAssertEqual(categories[0], expectedItem(at: 0))
            XCTAssertEqual(categories[1], expectedItem(at: 1))
            XCTAssertEqual(categories[2], expectedItem(at: 2))
            
        case let .failure(error)?:
            XCTFail("Expected successful categories result, got \(error) instead")
        
        default:
            XCTFail("Expected successful categories result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getCategoriesResult(file: StaticString = #filePath, line: UInt = #line) -> CategoryResult? {
        let testServerURL = URL(string: "https://private-anon-f51dfcda52-androidtestmobgen.apiary-mock.com/categories")!
        let client = URLSessionHTTPClient()
        let loader = RemoteCategoryLoader(url: testServerURL, client: client)
        trackForMemoryLeacks(client, file: file, line: line)
        trackForMemoryLeacks(loader, file: file, line: line)
        
        let exp  = expectation(description: "Wait for load completion")
        
        var receviedResult: CategoryResult?
        loader.load { result in
            receviedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receviedResult
    }
    
    private func expectedItem(at index: Int) -> CategoryItem {
        CategoryItem(id: id(at: index), name: name(at: index))
    }
    
    private func id(at index: Int) -> Int {
        return [0, 1, 2][index]
    }
    
    private func name(at index: Int) -> String {
        return ["Books", "Houses", "Characters"][index]
    }
}
