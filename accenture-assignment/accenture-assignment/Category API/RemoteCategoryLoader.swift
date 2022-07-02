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
    
    typealias Result = CategoryResult<Error>
    
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
                completion(CategoryItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connecitivy))
            }
        }
    }
}
