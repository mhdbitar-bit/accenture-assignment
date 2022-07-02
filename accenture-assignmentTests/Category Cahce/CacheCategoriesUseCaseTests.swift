@testable import accenture_assignment
import XCTest

class LocalCategoryLoader {
    private let store: CategoryStore
    private let currentDate: () -> Date
    
    init(store: CategoryStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ categories: [CategoryItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedCategories { [unowned self] error in
            completion(error)
            if error == nil {
                self.store.insert(categories, timestamp: self.currentDate())
            }
        }
    }
}

class CategoryStore {
    typealias DeletionCompletion = (Error?) -> Void
        
    enum ReceivedMessage: Equatable {
        case deleteCahcedCategories
        case insert([CategoryItem], Date)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedCategories(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCahcedCategories)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.none)
    }
    
    func insert(_ categories: [CategoryItem], timestamp: Date) {
        receivedMessages.append(.insert(categories, timestamp))
    }
}

final class CacheCategoriesUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        
        sut.save(items) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCahcedCategories])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCahcedCategories])
    }
    
    func test_save_requestNewCahceInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let items = [uniqueCategory(), uniqueCategory()]
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCahcedCategories, .insert(items, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueCategory(), uniqueCategory()]
        let deletionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletion(with: deletionError)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, deletionError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCategoryLoader, store: CategoryStore) {
        let store = CategoryStore()
        let sut = LocalCategoryLoader(store: store, currentDate: currentDate)
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
