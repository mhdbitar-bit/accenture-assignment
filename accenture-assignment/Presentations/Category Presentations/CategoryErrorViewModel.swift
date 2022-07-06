//
//  CategoryErrorViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

struct CategoryErrorViewModel {
    let message: String?
    
    static var noError: CategoryErrorViewModel {
        return CategoryErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> CategoryErrorViewModel {
        return CategoryErrorViewModel(message: message)
    }
}
