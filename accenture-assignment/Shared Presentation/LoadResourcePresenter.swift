//
//  LoadResourcePresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

final class LoadResourcePresenter<Resource, View: ResourceView> {
    typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private var resourceView: View
    private var loadingView: CategoryLoadingView
    private var errorView: CategoryErrorView
    private let mapper: Mapper
    
    private let LoadError: String = "Couldn't connect to the server"
    
    init(resourceView: View, loadingView: CategoryLoadingView, errorView: CategoryErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(CategoryLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(CategoryLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        errorView.display(.error(message: LoadError))
        loadingView.display(CategoryLoadingViewModel(isLoading: false))
    }
}
