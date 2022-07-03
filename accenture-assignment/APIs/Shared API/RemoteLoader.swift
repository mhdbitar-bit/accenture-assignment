//
//  RemoteLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

final class RemoteLoader<Resource> {
    private let url: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    enum Error: Swift.Error {
        case connecitivy
        case invalidData
    }
    
    typealias Result = Swift.Result<Resource, Swift.Error>
    typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    init(url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
               
            case .failure:
                completion(.failure(Error.connecitivy))
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
