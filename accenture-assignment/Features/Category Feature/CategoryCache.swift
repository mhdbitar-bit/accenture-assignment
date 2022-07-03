//
//  CategoryCache.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

protocol CategoryCache {
    typealias SaveResult = Error?
    
    func save(_ categories: [CategoryItem], completion: @escaping (SaveResult) -> Void)
}
