//
//  RemoteImageDataLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation

final class RemoteImageDataLoader: ImageDataLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case connecitivy
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: ImageDataLoaderTask {
        private var completion: ((ImageDataResult) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (ImageDataResult) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageDataResult) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataResult) -> Void) -> ImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in Error.connecitivy }
                .flatMap { (data, response) in
                    let isValidResponse = response.statusCode == 200 && data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        
        return task
    }
}
