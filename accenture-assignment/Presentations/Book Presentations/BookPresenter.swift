//
//  BookPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/6/22.
//

import Foundation

final class BookPresenter {
    static func map(_ books: [BookItem]) -> BookViewModel {
        return BookViewModel(books: books)
    }
}
