//
//  HouseCellController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit
import Combine

final class HouseCellController {
    private let viewModel: HouseImageViewModel<UIImage>
    private var cancellables: Set<AnyCancellable> = []
    private var cell: HouseTableViewCell?
    
    init(viewModel: HouseImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: HouseTableViewCell.ID) as? HouseTableViewCell
        bind(cell)
        viewModel.loadImageData()
        return cell!
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancleImageDataload()
    }
    
    private func bind(_ cell: HouseTableViewCell?) {
        cell?.houseNameLabel.text = viewModel.name
        cell?.houseTitleLabel.text = viewModel.title
        viewModel.$onImageLoad.sink { [weak cell] image in
            if let image = image {
                cell?.houseImage.image = image
            } else {
                cell?.houseImage.image = UIImage(systemName: "photo.fill")
            }
        }.store(in: &cancellables)
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
