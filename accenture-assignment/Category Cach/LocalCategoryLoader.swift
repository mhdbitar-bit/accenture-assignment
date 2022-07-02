//
//  LocalCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

final class LocalCategoryLoader {
    private let store: CategoryStore
    private let currentDate: () -> Date
    
    typealias SaveResult = Error?
    typealias LoadResult = LoadCategoryResult
    
    init(store: CategoryStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ categories: [CategoryItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedCategories { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(categories, with: completion)
            }
        }
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success([]))
            }
        }
    }
    
    private func cache(_ categories: [CategoryItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(categories.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == CategoryItem {
    func toLocal() -> [LocalCategoryItem] {
        map { LocalCategoryItem(id: $0.id, name: $0.name) }
    }
}
