//
//  CharacterViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

final class CharacterViewModel {
    let loader: CharacterLoader
    
    let title = "Characters"
    @Published var characters: [CharacterItem] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(loader: CharacterLoader) {
        self.loader = loader
    }
    
    func loadCharacters() {
        isLoading = true
        loader.load { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let characters):
                self.characters = characters
                
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
