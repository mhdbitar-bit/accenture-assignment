//
//  CategoryEndpoint.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

enum CategoryEndpoint {
    case getCategories
    
    func url(baseURL: URL) -> URL {
        switch self {
        case .getCategories:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/categories"
            components.queryItems = []
            return components.url!
        }
    }
}
