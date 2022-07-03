//
//  Endpoints.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

enum Endpoints {
    case getCategories
    case getLists(Int)
    
    func url(baseURL: URL) -> URL {
        switch self {
        case .getCategories:
            return make(baseURL: baseURL, path: "/categories")
        case let .getLists(id):
            return make(baseURL: baseURL, path: "/list/\(id)")
        }
    }
    
    private func make(baseURL: URL, path: String) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + path
        components.queryItems = []
        return components.url!
    }
}
