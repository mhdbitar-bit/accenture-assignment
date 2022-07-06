@testable import accenture_assignment
import XCTest

final class CategoryPresenterTests: XCTestCase {

    func test_map_createsViewModels() {
        let categories = uniqueCategories().models
        
        let viewModel = CategoryPresenter.map(categories)
        
        XCTAssertEqual(viewModel.categories, categories)
    }
}
