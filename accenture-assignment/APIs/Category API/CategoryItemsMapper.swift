//
//  CategoryItemsMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

final class CategoryItemsMapper {
    private static var OK_200: Int { 200 }
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [CategoryItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteCategoryItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return items.toModels()
    }
}

private extension Array where Element == RemoteCategoryItem {
    func toModels() -> [CategoryItem] {
        map { CategoryItem(id: $0.type, name: $0.category_name) }
    }
}
