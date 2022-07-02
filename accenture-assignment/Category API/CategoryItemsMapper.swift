//
//  CategoryItemsMapper.swift
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

final class CategoryItemsMapper {
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteCategoryItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteCategoryItem].self, from: data) else {
            throw RemoteCategoryLoader.Error.invalidData
        }
        
        return items
    }
}
