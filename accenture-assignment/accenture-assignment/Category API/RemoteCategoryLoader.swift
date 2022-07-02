//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

protocol HTTPClient {
    typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

final class RemoteCategoryLoader {
    private let url: URL
    private let client: HTTPClient
    
    typealias CategoryResult = Result<[CategoryItem], Error>
    
    enum Error: Swift.Error {
        case connecitivy
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (CategoryResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, let items = try? JSONDecoder().decode([Item].self, from: data) {
                    completion(.success(items.map { $0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connecitivy))
            }
        }
    }
}

private struct Item: Decodable {
    let type: Int
    let category_name: String
    
    var item: CategoryItem {
        return CategoryItem(id: type, name: category_name)
    }
}
