//
//  Category.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

struct Category: Equatable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Category: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "type"
        case name = "category_name"
    }
}
