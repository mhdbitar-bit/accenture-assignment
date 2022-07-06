//
//  CategoriesRefreshViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

protocol CategoriesRefreshViewControllerDelegate {
    func didRequestCategoriesRefresh()
}

final class CategoriesRefreshViewController: NSObject, ResourceLoadingView {
    private(set) lazy var view = loadView()
    
    private let delegate: CategoriesRefreshViewControllerDelegate
    
    init(delegate: CategoriesRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    var onRefresh: (([CategoryItem]) -> Void)?
    
    @objc func refresh() {
        delegate.didRequestCategoriesRefresh()
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
