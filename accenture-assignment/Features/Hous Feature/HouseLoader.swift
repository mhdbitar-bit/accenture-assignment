//
//  HouseLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/4/22.
//

import Foundation

typealias LoadHouseResult = Result<[HouseItem], Error>

protocol HouseLoader {
    func load(completion: @escaping (LoadHouseResult) -> Void)
}
