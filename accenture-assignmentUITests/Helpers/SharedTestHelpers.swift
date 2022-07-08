//
//  SharedTestHelpers.swift
//  accenture-assignmentUITests
//
//  Created by Mohammad Bitar on 7/8/22.
//

@testable import accenture_assignment

func makeCategory(id: Int = 0, name: String = "a name") -> CategoryItem {
    return CategoryItem(id: id, name: name)
}

func makeBook(name: String = "a name", isbn: String = "a isbn", numberOfPages: Int = 0, country: String = "a country", publisher: String = "a publisher", mediaType: String = "a media type", released: String = "1996-08-01T00:00:00", authors: [String] = ["an author"]) -> BookItem {
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
