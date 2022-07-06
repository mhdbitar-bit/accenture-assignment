//
//  WeakRefVirtualProxy.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: CategoryErrorView where T: CategoryErrorView {
    func display(_ viewModel: CategoryErrorViewModel) {
        object?.display(viewModel)
    }
}
