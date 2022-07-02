//
//  CategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

typealias LoadCategoryResult = Result<[CategoryItem], Error>

protocol CategoryLoader {
    func load(completion: @escaping (LoadCategoryResult) -> Void)
}
