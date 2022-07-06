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
        
        let presnter = CategoryPresenter(
            categoryView: CategoryViewAdapter(controller: categoriesController),
            loadingView: WeakRefVirtualProxy(refreshController)
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

private final class CategoryLoaderPresentationAdapter: CategoriesRefreshViewControllerDelegate {
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
