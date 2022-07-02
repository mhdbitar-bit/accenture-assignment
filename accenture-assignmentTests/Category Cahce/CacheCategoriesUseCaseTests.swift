@testable import accenture_assignment
import XCTest

class LocalCategoryLoader {
    private let store: CategoryStore
    
    init(store: CategoryStore) {
        self.store = store
    }
    
    func save(_ categories: [CategoryItem]) {
        store.deleteCachedCategories { [unowned self] error in
            if error == nil {
                self.store.insert(categories)
            }
        }
    }
}

class CategoryStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    var deleteCachedCategoriesCallCount = 0
    var insertCallCount = 0
    
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedCategories(completion: @escaping DeletionCompletion) {
        deleteCachedCategoriesCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.none)
    }
    
    func insert(_ categories: [CategoryItem]) {
        insertCallCount += 1
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
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_requestNewCahceInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        
        sut.save(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.insertCallCount, 1)
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
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
