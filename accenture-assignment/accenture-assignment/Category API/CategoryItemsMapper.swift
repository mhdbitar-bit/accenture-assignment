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
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteCategoryLoader.CategoryResult {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([Item].self, from: data) else {
            return .failure(.invalidData)
        }
        
        let categories = items.map { $0.item }
        return .success(categories)
        
    }
}
