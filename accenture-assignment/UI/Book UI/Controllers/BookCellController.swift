//
//  BookCellController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit

final class BookCellController {
    private let model: BookItem
    
    init(model: BookItem) {
        self.model = model
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.ID) as! BookTableViewCell
        cell.bookTitleLabel.text = model.name
        cell.authorLabel.text = "by, " + convertArrayToString(items: model.authors)
        cell.releaseDateLabel.text = getFormattedReleasedDate(date: model.released)
        cell.noPagesLabel.text = "pages no. \(model.numberOfPages)"
        return cell
    }
    
    private func getFormattedReleasedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateWithFormate = dateFormatter.date(from: model.released) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: dateWithFormate)
        }
               
        return date
    }
}

extension Date {
    func formatToString(using formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
