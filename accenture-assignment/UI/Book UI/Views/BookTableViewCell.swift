//
//  BookTableViewCell.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    @IBOutlet private(set) var bookTitleLabel: UILabel!
    @IBOutlet private(set) var authorLabel: UILabel!
    @IBOutlet private(set) var releaseDateLabel: UILabel!
    @IBOutlet private(set) var noPagesLabel: UILabel!
    
    static let ID = "BookTableViewCell"
}
