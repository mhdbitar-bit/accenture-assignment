//
//  RemoteBooksLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class RemoteBooksLoader {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = LoadBookResult
    
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
                completion(RemoteBooksLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connecitivy))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try BooksItemMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
