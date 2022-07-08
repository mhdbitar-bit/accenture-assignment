//
//  CategoryLoaderCacheDecorator.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class CategoryLoaderCacheDecorator: CategoryLoader {
    private let decoratee: CategoryLoader
    private let cache: CategoryCache
    
    init(decoratee: CategoryLoader, cache: CategoryCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { categories in
                self?.cache.saveIgnoringResult(categories)
                return categories
            })
        }
    }
}

private extension CategoryCache {
    func saveIgnoringResult(_ categories: [CategoryItem]) {
        save(categories) { _ in }
    }
}
