//
//  CategoryLoaderWithFallbackComposite.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class CategoryLoaderWithFallbackComposite: CategoryLoader {
    private let primary: CategoryLoader
    private let fallback: CategoryLoader
    
    init(primary: CategoryLoader, fallback: CategoryLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (LoadCategoryResult) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
