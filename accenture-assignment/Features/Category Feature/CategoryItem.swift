//
//  Category.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

struct CategoryItem: Equatable {
    let id: Int
    let name: String
    
    var category: Category {
        switch id {
        case 0:
            return .Books
        case 1:
            return .Houses
        case 2:
            return .Characters
        default: return .Books
        }
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

enum Category: Int {
    case Books = 1
    case Houses = 2
    case Characters = 3
}
