//
//  BooksItemMapper.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class BooksItemMapper {
    private struct RemoteBookItem: Decodable {
        let name: String
        let isbn: String
        let numberOfPages: Int
        let country: String
        let publisher: String
        let mediaType: String
        let released: String
        let authors: [String]

        var item: BookItem {
            return BookItem(
                name: name,
                isbn: isbn,
                numberOfPages: numberOfPages,
                country: country,
                publisher: publisher,
                mediaType: mediaType,
                released: released,
                authors: authors
            )
        }
    }

    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [BookItem] {
        guard response.statusCode == OK_200,
              let items = try? JSONDecoder().decode([RemoteBookItem].self, from: data) else {
            throw RemoteBooksLoader.Error.invalidData
        }
        
        return items.map { $0.item }
    }
}
