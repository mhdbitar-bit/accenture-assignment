//
//  CategoryStore.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

enum RetrieveCachedCategoriesResult {
    case empty
    case found(categories: [LocalCategoryItem], timestamp: Date)
    case failure(Error)
}

protocol CategoryStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedCategoriesResult) -> Void
    
    func deleteCachedCategories(completion: @escaping DeletionCompletion)
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
