//
//  CategoryCacheTestHelpers.swift
//  accenture-assignmentTests
//
//  Created by Mohammad Bitar on 7/2/22.
//

import Foundation
@testable import accenture_assignment

func uniqueCategory() -> CategoryItem {
    CategoryItem(id: 1, name: "any")
}

func uniqueCategories() -> (models: [CategoryItem], local: [LocalCategoryItem]) {
    let models = [uniqueCategory(), uniqueCategory()]
    let local = models.map { LocalCategoryItem(id: $0.id, name: $0.name) }
    return (models, local)
}

extension Date {
    private var categoriesCacheMaxAgeInDays: Int {
        return 7
    }
    
    func minusCategoriesCacheMaxAge() -> Date {
        return adding(days: -categoriesCacheMaxAgeInDays)
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
