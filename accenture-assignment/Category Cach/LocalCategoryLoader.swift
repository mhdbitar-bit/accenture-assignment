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
    private let calendar = Calendar(identifier: .gregorian)
    
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
        store.retrieve { [unowned self] result in
            switch result {
            case let .failure(error):
                self.store.deleteCachedCategories() { _ in }
                completion(.failure(error))
            
            case let .found(categories, timestamp) where self.validate(timestamp):
                completion(.success(categories.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
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

private extension Array where Element == LocalCategoryItem {
    func toModels() -> [CategoryItem] {
        map { CategoryItem(id: $0.id, name: $0.name) }
    }
}
