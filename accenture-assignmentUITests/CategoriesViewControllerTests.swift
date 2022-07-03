@testable import accenture_assignment
import XCTest

class CategoriesViewController {
    init(loader: CategoriesViewControllerTests.LoaderSpy) {
        
    }
}

final class CategoriesViewControllerTests: XCTestCase {

    func test_init_doesNoLoadCategories() {
        let loader = LoaderSpy()
        let sut = CategoriesViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
