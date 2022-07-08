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
        case 1:
            return .Books
        case 2:
            return .Houses
        case 3:
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
    case Books
    case Houses
    case Characters
}
