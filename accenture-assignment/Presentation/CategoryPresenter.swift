//
//  CategoryPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import Foundation

protocol CategoryLoadingView {
    func display(isLoading: Bool)
}

protocol CategoryView {
    func display(categories: [CategoryItem])
}

final class CategoryPresenter {
    typealias Observer<T> = (T) -> Void
    
    private let categoryLoader: CategoryLoader
    
    init(categoryLoader: CategoryLoader) {
        self.categoryLoader = categoryLoader
    }
    
    var categoryView: CategoryView?
    var loadingView: CategoryLoadingView?
    
    func loadCategories() {
        loadingView?.display(isLoading: true)
        categoryLoader.load { [weak self] result in
            if let categories = try? result.get() {
                self?.categoryView?.display(categories: categories)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
