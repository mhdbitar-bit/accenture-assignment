//
//  CategoryViewAdapter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

final class CategoryViewAdapter: CategoryView {
    private weak var controller: CategoriesViewController?
    
    init(controller: CategoriesViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: CategoryViewModel) {
        controller?.tablewModel = viewModel.categories
    }
}
