//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

final class RemoteCategoryLoader: CategoryLoader {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = LoadCategoryResult
    
    enum Error: Swift.Error {
        case connecitivy
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteCategoryLoader.map(data, from: response))
               
            case .failure:
                completion(.failure(Error.connecitivy))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try CategoryItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteCategoryItem {
    func toModels() -> [CategoryItem] {
        map { CategoryItem(id: $0.type, name: $0.category_name) }
    }
}
