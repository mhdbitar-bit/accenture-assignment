//
//  CategoryViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

final class CategoryViewModel {
    
    let loader: CategoryLoader
    
    let title = "Categories"
    @Published var categories: [CategoryItem] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(loader: CategoryLoader) {
        self.loader = loader
    }
    
    func loadCategories() {
        isLoading = true
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let categories):
                self.categories = categories.sorted { $0.name < $1.name }
                
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
