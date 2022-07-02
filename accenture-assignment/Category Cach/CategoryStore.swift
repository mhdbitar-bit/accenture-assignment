//
//  CategoryStore.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

protocol CategoryStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedCategories(completion: @escaping DeletionCompletion)
    func insert(_ categories: [CategoryItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
