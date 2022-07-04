//
//  HouseItemMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

final class HouseItemMapper {
    private struct RemoteHouseItem: Decodable {
        let id: String
        let name: String
        let region: String
        let title: String
        
        var item: HouseItem {
            return HouseItem(
                id: id,
                name: name,
                region: region,
                title: title
            )
        }
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }

    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [HouseItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteHouseItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return items.map { $0.item }
    }
}
