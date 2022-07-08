//
//  CharacterViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation
import Combine

//final class CharacterViewModel {
//    let loader: CharacterLoader
//    
//    let title = "Books"
//    @Published var books: [BookItem] = []
//    @Published var isLoading: Bool = false
//    @Published var error: String? = nil
//    
//    init(loader: BookLoader) {
//        self.loader = loader
//    }
//    
//    func loadBooks() {
//        isLoading = true
//        loader.load { [weak self] result in
//            guard let self = self else { return }
//            
//            self.isLoading = false
//            switch result {
//            case .success(let books):
//                self.books = books
//                
//            case .failure(let error):
//                self.error = error.localizedDescription
//            }
//        }
//    }
//}
