//
//  SplashViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

final class SplashViewModel {
    
    let loader: CategoryLoader
    
    @Published var categories: [CategoryItem] = []
    @Published var error: String? = nil
    
    init(loader: CategoryLoader) {
        self.loader = loader
    }
    
    func loadCategories() {
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                self.categories = categories
                
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
