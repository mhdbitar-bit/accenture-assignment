//
//  CategoryCellController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import UIKit

final class CategoryCellController {
    private let model: CategoryItem
    
    init(model: CategoryItem) {
        self.model = model
    }
    
    func view() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = model.name
        return cell
    }
}
