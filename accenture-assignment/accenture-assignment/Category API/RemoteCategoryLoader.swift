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
                do {
                    let items = try CategoryItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connecitivy))
            }
        }
    }
}

private class CategoryItemsMapper {
    private struct Item: Decodable {
        let type: Int
        let category_name: String
        
        var item: CategoryItem {
            return CategoryItem(id: type, name: category_name)
        }
    }
    
    static var OK_200: Int { 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [CategoryItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteCategoryLoader.Error.invalidData
        }
        return try JSONDecoder().decode([Item].self, from: data).map { $0.item }
    }
}
