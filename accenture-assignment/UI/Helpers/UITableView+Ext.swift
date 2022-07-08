//
//  UITableView+Ext.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit

extension UITableViewController {
    func startLoading() {
        refreshControl?.beginRefreshing()
    }
    
    func stopLoading() {
        if Thread.isMainThread {
            refreshControl?.endRefreshing()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        }
    }
}
