//
//  CategoriesViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoriesViewController: UITableViewController {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoryCellController(model: tablewModel[indexPath.row]).view()
    }
}
