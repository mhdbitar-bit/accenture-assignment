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
    
    typealias CategoryResult = Result<[Category], Error>
    
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
            case let .success((data, _)):
                if let items = try? JSONDecoder().decode([Category].self, from: data) {
                    completion(.success(items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connecitivy))
            }
        }
    }
}
