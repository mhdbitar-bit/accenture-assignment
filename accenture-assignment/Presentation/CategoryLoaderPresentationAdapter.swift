//
//  CategoryLoaderPresentationAdapter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

final class CategoryLoaderPresentationAdapter: CategoriesRefreshViewControllerDelegate {
    private let categoryLoader: CategoryLoader
    var presenter: CategoryPresenter?
    
    init(categoryLoader: CategoryLoader) {
        self.categoryLoader = categoryLoader
    }
    
    func didRequestCategoriesRefresh() {
        presenter?.didStartLoadingCategories()
        
        categoryLoader.load { [weak self] result in
            switch result {
            case let .success(categories):
                self?.presenter?.didFinishLoadingCategories(with: categories)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingCategories(with: error)
            }
        }
    }
}
