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
        cell.authorLabel.text = convertArrayToString(items: model.authors)
        cell.releaseDateLabel.text = getFormattedReleasedDate(date: model.released)
        cell.noPagesLabel.text = "\(model.numberOfPages)"
        return cell
    }
    
    private func getFormattedReleasedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let dateWithFormate = dateFormatter.date(from: model.released) {
            return dateWithFormate.formatToString(using: dateFormatter)
        }
        
        return date
    }
}

extension Date {
    func formatToString(using formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}