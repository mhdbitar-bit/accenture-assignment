//
//  CategoryItemsMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

final class CategoryItemsMapper {
    private struct Item: Decodable {
        let type: Int
        let category_name: String
        
        var item: CategoryItem {
            return CategoryItem(id: type, name: category_name)
        }
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [CategoryItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteCategoryLoader.Error.invalidData
        }
        return try JSONDecoder().decode([Item].self, from: data).map { $0.item }
    }
}
