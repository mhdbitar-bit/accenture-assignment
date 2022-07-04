//
//  CharacterItemMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

final class CharacterItemMapper {
    private struct RemoteCharacterItem: Decodable {
        let id: String
        let name: String
        let gender: String
        let culture: String
        let born: String
        let died: String
        let father: String
        let mother: String
        let spouse: String
        let titles: [String]
        let aliases: [String]
        let playedBy: [String]
        let allegiances: [URL]
        
        var item: CharacterItem {
            return CharacterItem(
                id: id,
                name: name,
                gender: gender,
                culture: culture,
                born: born,
                died: died,
                father: father,
                mother: mother,
                spouse: spouse,
                titles: titles,
                aliases: aliases,
                playedBy: playedBy,
                allegiances: allegiances
            )
        }
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }

    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [CharacterItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteCharacterItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return items.map { $0.item }
    }
}
