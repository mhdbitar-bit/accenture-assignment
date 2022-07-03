//
//  BookItem.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

struct BookItem: Equatable {
    let name: String
    let isbn: String
    let numberOfPages: Int
    let country: String
    let publisher: String
    let mediaType: String
    let released: String
    let authors: [String]
    
    init(name: String, isbn: String, numberOfPages: Int, country: String, publisher: String, mediaType: String, released: String, authors: [String]) {
        self.name = name
        self.isbn = isbn
        self.numberOfPages = numberOfPages
        self.country = country
        self.publisher = publisher
        self.mediaType = mediaType
        self.released = released
        self.authors = authors
    }
}
