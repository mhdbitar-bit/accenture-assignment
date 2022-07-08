//
//  ImageDataLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation

protocol ImageDataLoaderTask {
    func cancel()
}

typealias ImageDataResult = Result<Data, Error>

protocol ImageDataLoader {
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataResult) -> Void) -> ImageDataLoaderTask
}
