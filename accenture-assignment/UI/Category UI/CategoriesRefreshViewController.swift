//
//  CategoriesRefreshViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoriesRefreshViewController: NSObject, CategoryLoadingView {
    private(set) lazy var view = loadView()
    
    private let presenter: CategoryPresenter
    
    init(presenter: CategoryPresenter) {
        self.presenter = presenter
    }
    
    var onRefresh: (([CategoryItem]) -> Void)?
    
    @objc func refresh() {
        presenter.loadCategories()
    }
    
    func display(isLoading: Bool) {
        if isLoading {
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
