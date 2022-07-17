//
//  CharactersTableViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit
import Combine

final class CharactersTableViewController: UITableViewController, Alertable {
    
    private var viewModel: CharacterViewModel!
    private var cancelable: Set<AnyCancellable> = []
    
    private var characters = [CharacterItem]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(viewModel: CharacterViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
        tableView.register(UINib(nibName: CharacterTableViewCell.ID, bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.ID)
        setupRefreshControl()
        bind()
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            refresh()
        }
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        viewModel.loadCharacters()
    }
    
    private func bind() {
        bindLoading()
        bindError()
        bindBooks()
    }
    
    private func bindLoading() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }.store(in: &cancelable)
    }
    
    private func bindBooks() {
        viewModel.$characters.sink { [weak self] characters in
            guard let self = self else { return }
            self.characters = characters
        }.store(in: &cancelable)
    }
    
    private func bindError() {
        viewModel.$error.sink { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error)
            }
        }.store(in: &cancelable)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CharacterCellController(model: characters[indexPath.row]).view(tableView)
    }
}
