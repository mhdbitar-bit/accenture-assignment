//
//  CategoryErrorViewModel.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

struct ResourceErrorViewModel {
    let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: .none)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
