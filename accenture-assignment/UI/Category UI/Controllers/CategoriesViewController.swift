//
//  CategoriesViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit
import Combine

final class CategoriesViewController: UITableViewController, Alertable {

    private var viewModel: CategoryViewModel!
    private var onSelect: ((CategoryItem) -> Void)?
    private var cancellables: Set<AnyCancellable> = []
    
    private var categories = [CategoryItem]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(viewModel: CategoryViewModel, onSelect: ((CategoryItem) -> Void)?) {
        self.init()
        self.viewModel = viewModel
        self.onSelect = onSelect
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        setupRefreshControl()
        bind()
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            refresh()
        }
    }
}

// MARK: - Setup

extension CategoriesViewController {
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        viewModel.loadCategories()
    }
}

// MARK: - Binding

extension CategoriesViewController {
    private func bind() {
        bindLoading()
        bindError()
        bindCategories()
    }
    
    private func bindLoading() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }.store(in: &cancellables)
    }
        
    private func bindCategories() {
        viewModel.$categories.sink { [weak self] categories in
            guard let self = self else { return }
            self.categories = categories
        }.store(in: &cancellables)
    }
    
    private func bindError() {
        viewModel.$error.sink { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error)
            }
        }.store(in: &cancellables)
    }
}

// MARK: - TableView

extension CategoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoryCellController(model: categories[indexPath.row]).view()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(categories[indexPath.row])
    }
}
