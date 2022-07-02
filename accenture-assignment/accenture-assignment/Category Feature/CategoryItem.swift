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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension CategoryItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "type"
        case name = "category_name"
    }
}
