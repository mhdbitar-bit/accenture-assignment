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
    URL(string: "http://any-url.com")!
}

func uniqueCategoriesModel() -> [CategoryItem] {
    return [CategoryItem(id: 0, name: "a name")]
}
