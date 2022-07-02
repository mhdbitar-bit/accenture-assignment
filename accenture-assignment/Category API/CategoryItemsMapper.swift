//
//  CategoryItemsMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

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
