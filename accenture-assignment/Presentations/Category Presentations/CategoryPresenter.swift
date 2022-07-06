//
//  CategoryPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import Foundation

protocol CategoryView {
    func display(_ viewModel: CategoryViewModel)
}

protocol CategoryErrorView {
    func display(_ viewModel: CategoryErrorViewModel)
}

final class CategoryPresenter {
    private var categoryView: CategoryView
    private var loadingView: ResourceLoadingView
    private var errorView: CategoryErrorView
    
    init(categoryView: CategoryView, loadingView: ResourceLoadingView, errorView: CategoryErrorView) {
        self.categoryView = categoryView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    func didStartLoadingCategories() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingCategories(with categories: [CategoryItem]) {
        categoryView.display(CategoryViewModel(categories: categories))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingCategories(with error: Error) {
        errorView.display(.error(message: "Connectivity error"))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
