//
//  RemoteCategoryItem.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

struct RemoteCategoryItem: Decodable {
    let type: Int
    let category_name: String
    
    var item: CategoryItem {
        return CategoryItem(id: type, name: category_name)
    }
}
