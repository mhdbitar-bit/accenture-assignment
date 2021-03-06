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
    
    init(store: CategoryStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalCategoryLoader: CategoryCache {
    typealias SaveResult = CategoryCache.SaveResult
    
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
    
    private func cache(_ categories: [CategoryItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(categories.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

extension LocalCategoryLoader: CategoryLoader {
    typealias LoadResult = LoadCategoryResult
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            
            case let .found(categories, timestamp) where CategoryCahcePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(categories.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalCategoryLoader {
    func validateCahce() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedCategories { _ in }
                
            case let .found(_, timestamp) where !CategoryCahcePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedCategories { _ in }
                
            case .empty, .found: break
            }
        }
    }
}

private extension Array where Element == CategoryItem {
    func toLocal() -> [LocalCategoryItem] {
        map { LocalCategoryItem(id: $0.id, name: $0.name) }
    }
}

private extension Array where Element == LocalCategoryItem {
    func toModels() -> [CategoryItem] {
        map { CategoryItem(id: $0.id, name: $0.name) }
    }
}
