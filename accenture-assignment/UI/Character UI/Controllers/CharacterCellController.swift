//
//  CharacterCellController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit

final class CharacterCellController {
    private let model: CharacterItem
    
    init(model: CharacterItem) {
        self.model = model
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.ID) as! CharacterTableViewCell
        cell.characterNameLabel.text = model.name
        cell.actorLabel.text = convertArrayToString(items: model.playedBy)
        return cell
    }
}
