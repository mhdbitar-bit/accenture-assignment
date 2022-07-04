//
//  RemoteCategoryLoader.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import Foundation

typealias RemoteCategoryLoader = RemoteLoader<[CategoryItem]>

extension RemoteCategoryLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: CategoryItemsMapper.map)
    }
}
