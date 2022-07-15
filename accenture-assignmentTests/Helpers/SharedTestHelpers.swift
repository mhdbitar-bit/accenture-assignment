//
//  SharedTestHelpers.swift
//  accenture-assignmentTests
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation
@testable import accenture_assignment

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyHTTPURLResponse() -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func nonHTTPURLResponse() -> URLResponse {
    URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func uniqueCategoriesModel() -> [CategoryItem] {
    return [CategoryItem(id: 0, name: "a name")]
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: items)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

func makeCategory(id: Int = 0, name: String = "a name") -> CategoryItem {
    return CategoryItem(id: id, name: name)
}

func makeBook(name: String = "a name", isbn: String = "a isbn", numberOfPages: Int = 0, country: String = "a country", publisher: String = "a publisher", mediaType: String = "a media type", released: String = "1996-08-01T00:00:00", authors: [String] = ["a author"]) -> BookItem {
    return BookItem(
        name: name,
        isbn: isbn,
        numberOfPages: numberOfPages,
        country: country,
        publisher: publisher,
        mediaType: mediaType,
        released: released,
        authors: authors)
}

func makeCharacter(
    id: String = "id",
    name: String = "a name",
    gender: String = "gender",
    culture: String = "culture",
    born: String = "born",
    died: String = "died",
    father: String = "father",
    mother: String = "mother",
    spouse: String = "spouse",
    titles: [String] = ["title 1"],
    aliases: [String] = ["aliases"],
    playedBy: [String] = ["actor"],
    allegiances: [URL] = [URL(string: "http:/a-url.com")!]
) -> CharacterItem {
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
        allegiances: allegiances)
}
