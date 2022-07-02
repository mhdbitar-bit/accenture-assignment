//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

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
                completion(CategoryItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connecitivy))
            }
        }
    }
}
