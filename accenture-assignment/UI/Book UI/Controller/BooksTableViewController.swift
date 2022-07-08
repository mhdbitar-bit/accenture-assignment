//
//  BooksTableViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit
import Combine

final class BooksTableViewController: UITableViewController, Alertable {
    
    private var viewModel: BookViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var books = [BookItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(viewModel: BookViewModel) {
        self.init()
        self.viewModel = viewModel
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

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        viewModel.loadBooks()
    }
    
    private func bind() {
        bindLoading()
        bindError()
        bindBooks()
    }
    
    private func bindLoading() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.refreshControl?.beginRefreshing()
            } else {
                self?.refreshControl?.endRefreshing()
            }
        }.store(in: &cancellables)
    }
    
    private func bindBooks() {
        viewModel.$books.sink { [weak self] books in
            guard let self = self else { return }
            self.books = books
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return BookCellController(model: books[indexPath.row]).view()
    }
}
