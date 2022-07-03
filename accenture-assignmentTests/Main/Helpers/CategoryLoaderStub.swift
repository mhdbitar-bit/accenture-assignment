//
//  CategoryLoaderStub.swift
//  accenture-assignmentTests
//
//  Created by Mohammad Bitar on 7/3/22.
//

@testable import accenture_assignment
import Foundation

class CategoryLoaderStub: CategoryLoader {
    private let result: LoadCategoryResult
    
    init(result: LoadCategoryResult) {
        self.result = result
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        completion(result)
    }
}
