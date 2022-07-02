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
    
    func save(_ categories: [CategoryItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedCategories { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(categories, with: completion)
            }
        }
    }
    
    private func cache(_ categories: [CategoryItem], with completion: @escaping (Error?) -> Void) {
        store.insert(categories, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
