//
//  CategoriesRefreshViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoriesRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let loader: CategoryLoader
    
    init(loader: CategoryLoader) {
        self.loader = loader
    }
    
    var onRefresh: (([CategoryItem]) -> Void)?
    
    @objc func refresh() {
        startLoading()
        loader.load { [weak self] result in
            if let categories = try? result.get() {
                self?.onRefresh?(categories)
            }
            self?.stopLoading()
        }
    }
    
    private func startLoading() {
        DispatchQueue.main.async { [self] in
            self.view.beginRefreshing()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.view.endRefreshing()
        }
    }
}
