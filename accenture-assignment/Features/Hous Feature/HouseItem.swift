//
//  HouseItem.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

struct HouseItem: Equatable {
    let id: String
    let name: String
    let region: String
    let title: String
    
    init(id: String, name: String, region: String, title: String) {
        self.id = id
        self.name = name
        self.region = region
        self.title = title
    }
}
