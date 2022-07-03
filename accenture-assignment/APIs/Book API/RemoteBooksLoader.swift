//
//  RemoteBooksLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/3/22.
//

import Foundation

typealias RemoteBooksLoader = RemoteLoader<[BookItem]>

extension RemoteBooksLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: BooksItemMapper.map)
    }
}
