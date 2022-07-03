//
//  SharedTestHelpers.swift
//  accenture-assignmentTests
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation
@testable import accenture_assignment

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func uniqueCategoriesModel() -> [CategoryItem] {
    return [CategoryItem(id: 0, name: "a name")]
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: items)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
