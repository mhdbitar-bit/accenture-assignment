//
//  HouseTableViewCell.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import UIKit

final class HouseTableViewCell: UITableViewCell {
    @IBOutlet private(set) var houseImage: UIImageView!
    @IBOutlet private(set) var houseNameLabel: UILabel!
    @IBOutlet private(set) var houseTitleLabel: UILabel!
    
    static let ID = "HouseTableViewCell"
}
