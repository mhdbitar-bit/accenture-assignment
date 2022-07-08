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
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func deleteCachedCategories(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to approprate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
