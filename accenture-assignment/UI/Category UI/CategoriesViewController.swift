//
//  CategoriesViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoriesViewController: UITableViewController, CategoryErrorView {
    private var refreshController: CategoriesRefreshViewController?
    var tablewModel = [CategoryItem]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(refreshController: CategoriesRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    func display(_ viewModel: CategoryErrorViewModel) {
        guard let message = viewModel.message else { return }
        let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoryCellController(model: tablewModel[indexPath.row]).view()
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
