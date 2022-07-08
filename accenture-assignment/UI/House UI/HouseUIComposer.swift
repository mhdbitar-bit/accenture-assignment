//
//  HouseUIComposer.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit
import Combine

final class HouseUIComposer {
    private static var cancellables: Set<AnyCancellable> = []
    private init() {}
    
    static func housesComposedWith(houseloader: HouseLoader, imageLoader: ImageDataLoader) -> HousesTableViewController {
        let viewModel = HousesViewModel(loader: houseloader)
        let controller = HousesTableViewController(viewModel: viewModel)
        
        viewModel.$houses.sink { [weak controller] houses in
            controller?.tableModel = houses.map { model in
                HouseCellController(viewModel: HouseImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
            }
        }.store(in: &cancellables)
        return controller
    }
}
