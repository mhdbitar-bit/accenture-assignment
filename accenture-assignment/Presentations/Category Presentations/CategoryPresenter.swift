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

final class CategoryPresenter {
    private var categoryView: CategoryView
    private var loadingView: ResourceLoadingView
    private var errorView: ResourceErrorView
    
    let LoadError: String = "Couldn't connect to the server"
    
    init(categoryView: CategoryView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
        self.categoryView = categoryView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    func didStartLoadingCategories() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingCategories(with categories: [CategoryItem]) {
        categoryView.display(Self.map(categories))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingCategories(with error: Error) {
        errorView.display(.error(message: LoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    static func map(_ categories: [CategoryItem]) -> CategoryViewModel {
        return CategoryViewModel(categories: categories)
    }
}
