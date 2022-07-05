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
    var categoryView: CategoryView?
    var loadingView: CategoryLoadingView?
    
    func didStartLoadingCategories() {
        loadingView?.display(CategoryLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingCategories(with categories: [CategoryItem]) {
        categoryView?.display(CategoryViewModel(categories: categories))
        loadingView?.display(CategoryLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingCategories(with error: Error) {
        loadingView?.display(CategoryLoadingViewModel(isLoading: false))
    }
}
