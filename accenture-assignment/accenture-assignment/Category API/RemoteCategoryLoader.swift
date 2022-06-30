//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

protocol HTTPClient {
    typealias HTTPClientResult = Result<HTTPURLResponse, Error>
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

final class RemoteCategoryLoader {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connecitivy
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connecitivy)
            }
        }
    }
}
