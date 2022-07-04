//
//  BookLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

typealias LoadBookResult = Result<[BookItem], Error>

protocol BookLoader {
    func load(completion: @escaping (LoadBookResult) -> Void)
}
