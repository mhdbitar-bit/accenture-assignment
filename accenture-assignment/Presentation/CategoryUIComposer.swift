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
        presnter.loadingView = WeakRefVirtualProxy(refreshController)
        presnter.categoryView = CategoryViewAdapter(controller: categoriesController)
        return categoriesController
    }
    
    private static func adapterCategoriesToCellController(forwardingTo controller: CategoriesViewController) -> ([CategoryItem]) -> Void {
        return { [weak controller] categories in
            controller?.tablewModel = categories
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
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

private final class CategoryViewAdapter: CategoryView {
    private weak var controller: CategoriesViewController?
    
    init(controller: CategoriesViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: CategoryViewModel) {
        controller?.tablewModel = viewModel.categories
    }
}
