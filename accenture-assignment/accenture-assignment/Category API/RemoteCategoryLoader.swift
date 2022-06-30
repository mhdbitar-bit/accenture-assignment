//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

final class RemoteCategoryLoader {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connecitivy
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connecitivy)
        }
    }
}
