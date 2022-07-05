//
//  CategoryUIComposer.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import Foundation

final class CategoryUIComposer {
    private init() {}
    
    static func categoryComposedWith(categoryLoader: CategoryLoader) -> CategoriesViewController {
        let presnter = CategoryPresenter(categoryLoader: categoryLoader)
        let refreshController = CategoriesRefreshViewController(presenter: presnter)
        let categoriesController = CategoriesViewController(refreshController: refreshController)
        presnter.loadingView = refreshController
        presnter.categoryView = CategoryViewAdapter(controller: categoriesController)
        return categoriesController
    }
    
    private static func adapterCategoriesToCellController(forwardingTo controller: CategoriesViewController) -> ([CategoryItem]) -> Void {
        return { [weak controller] categories in
            controller?.tablewModel = categories
        }
    }
}

private final class CategoryViewAdapter: CategoryView {
    private weak var controller: CategoriesViewController?
    
    init(controller: CategoriesViewController) {
        self.controller = controller
    }
    
    func display(categories: [CategoryItem]) {
        controller?.tablewModel = categories
    }
}
