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
        let presentationAdapter = CategoryLoaderPresentationAdapter(
            categoryLoader: MainQueueDispatchDecorator(decoratee: categoryLoader)
        )
        
        let refreshController = CategoriesRefreshViewController(delegate: presentationAdapter)
        let categoriesController = CategoriesViewController(refreshController: refreshController)
        
        let presnter = LoadResourcePresenter(
            resourceView: CategoryViewAdapter(controller: categoriesController),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(categoriesController),
            mapper: CategoryPresenter.map
        )
        
        presentationAdapter.presenter = presnter
        
        return categoriesController
    }
    
    private static func adapterCategoriesToCellController(forwardingTo controller: CategoriesViewController) -> ([CategoryItem]) -> Void {
        return { [weak controller] categories in
            controller?.tablewModel = categories
        }
    }
}
