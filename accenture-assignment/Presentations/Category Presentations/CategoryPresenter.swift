//
//  CategoryPresenter.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/5/22.
//

import Foundation

final class CategoryPresenter {
    static func map(_ categories: [CategoryItem]) -> CategoryViewModel {
        return CategoryViewModel(categories: categories)
    }
}
