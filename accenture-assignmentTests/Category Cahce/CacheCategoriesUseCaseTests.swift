@testable import accenture_assignment
import XCTest

class LocalCategoryLoader {
    private let store: CategoryStore
    
    init(store: CategoryStore) {
        self.store = store
    }
    
    func save(_ categories: [CategoryItem]) {
        store.deleteCachedCategories()
    }
}

class CategoryStore {
    var deleteCachedCategoriesCallCount = 0
    
    func deleteCachedCategories() {
        deleteCachedCategoriesCallCount += 1
    }
}

final class CacheCategoriesUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedCategoriesCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedCategoriesCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCategoryLoader, store: CategoryStore) {
        let store = CategoryStore()
        let sut = LocalCategoryLoader(store: store)
        trackForMemoryLeacks(store, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueCategory() -> CategoryItem {
        CategoryItem(id: 1, name: "any")
    }
}
