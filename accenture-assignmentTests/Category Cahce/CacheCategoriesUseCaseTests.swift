@testable import accenture_assignment
import XCTest

class LocalCategoryLoader {
    init(store: CategoryStore) {
        
    }
}

class CategoryStore {
    var deleteCachedCategoriesCallCount = 0
}

final class CacheCategoriesUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = CategoryStore()
        _ = LocalCategoryLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedCategoriesCallCount, 0)
    }
}
