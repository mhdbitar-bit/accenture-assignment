//
//  HTTPClient.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

protocol HTTPClient {
    @discardableResult
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask
}
