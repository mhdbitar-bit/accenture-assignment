//
//  CategoryPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import Foundation

struct CategoryLoadingViewModel {
    let isLoading: Bool
}

protocol CategoryLoadingView {
    func display(_ viewModel: CategoryLoadingViewModel)
}

struct CategoryViewModel {
    let categories: [CategoryItem]
}

protocol CategoryView {
    func display(_ viewModel: CategoryViewModel)
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
        loadingView?.display(CategoryLoadingViewModel(isLoading: true))
        categoryLoader.load { [weak self] result in
            if let categories = try? result.get() {
                self?.categoryView?.display(CategoryViewModel(categories: categories))
            }
            self?.loadingView?.display(CategoryLoadingViewModel(isLoading: false))
        }
    }
}
