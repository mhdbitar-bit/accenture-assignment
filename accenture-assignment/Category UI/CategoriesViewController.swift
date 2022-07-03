//
//  CategoriesViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoriesViewController: UITableViewController {
    private var refreshController: CategoriesRefreshViewController?
    private var tablewModel = [CategoryItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    convenience init(loader: CategoryLoader) {
        self.init()
        self.refreshController = CategoriesRefreshViewController(loader: loader)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] categories in
            self?.tablewModel = categories
        }
        
        refreshController?.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoryCellController(model: tablewModel[indexPath.row]).view()
    }
}
