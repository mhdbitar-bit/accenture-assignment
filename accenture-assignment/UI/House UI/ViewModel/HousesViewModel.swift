//
//  HousesViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

final class HousesViewModel {
    let loader: HouseLoader
    
    let title = "houses"
    @Published var houses: [HouseItem] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(loader: HouseLoader) {
        self.loader = loader
    }
    
    func loadHouses() {
        isLoading = true
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let houses):
                self.houses = houses
                
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
