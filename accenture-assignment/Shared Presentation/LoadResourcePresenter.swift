//
//  LoadResourcePresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

protocol ResourceView {
    func display(_ viewModel: String)
}

final class LoadResourcePresenter {
    typealias Mapper = (String) -> String
    
    private var resourceView: ResourceView
    private var loadingView: CategoryLoadingView
    private var errorView: CategoryErrorView
    private let mapper: Mapper
    
    init(resourceView: ResourceView, loadingView: CategoryLoadingView, errorView: CategoryErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(CategoryLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(CategoryLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingCategories(with error: Error) {
        loadingView.display(CategoryLoadingViewModel(isLoading: false))
    }
}
