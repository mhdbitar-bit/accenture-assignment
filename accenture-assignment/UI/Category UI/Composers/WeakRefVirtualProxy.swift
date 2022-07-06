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

extension WeakRefVirtualProxy: CategoryLoadingView where T: CategoryLoadingView {
    func display(_ viewModel: CategoryLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: CategoryErrorView where T: CategoryErrorView {
    func display(_ viewModel: CategoryErrorViewModel) {
        object?.display(viewModel)
    }
}
