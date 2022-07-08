//
//  UITableViewController+Eet.swift
//  accenture-assignmentUITests
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import UIKit

extension UITableViewController {
    func simulateUserInitiatedResourceReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedResourceViews() -> Int {
        return tableView.numberOfRows(inSection: resourceSection)
    }
    
    func categoryView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: resourceSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var resourceSection: Int {
        return 0
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0))
            }
        }
    }
}
