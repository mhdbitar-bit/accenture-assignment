//
//  CategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

protocol CategoryLoader {
    func load(completion: @escaping (Result<[CategoryItem], Error>) -> Void)
}
