//
//  XCTestCase+CategoryLoader.swift
//  accenture-assignmentTests
//
//  Created by Mohammad Bitar on 7/3/22.
//

@testable import accenture_assignment
import XCTest

protocol CategoryLoaderTestCase: XCTestCase {}

extension CategoryLoaderTestCase {
    func expect(_ sut: CategoryLoader, toCompleteWith expectedResult: LoadCategoryResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedCategories), .success(expectedCategories)):
                XCTAssertEqual(receivedCategories, expectedCategories, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
