//
//  CategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

typealias CategoryResult<Error: Swift.Error> = Result<[CategoryItem], Error>

protocol CategoryLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (CategoryResult<Error>) -> Void)
}
