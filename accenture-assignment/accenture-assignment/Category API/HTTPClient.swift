//
//  HTTPClient.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation

protocol HTTPClient {
    typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
