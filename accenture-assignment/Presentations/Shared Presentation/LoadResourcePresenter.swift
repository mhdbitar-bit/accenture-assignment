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
    private var loadingView: ResourceLoadingView
    private var errorView: ResourceErrorView
    private let mapper: Mapper
    
    let LoadError: String = "Couldn't connect to the server"
    
    init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        errorView.display(.error(message: LoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
