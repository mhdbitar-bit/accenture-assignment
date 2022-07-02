@testable import accenture_assignment
import XCTest

final class ValidateCategoriesCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deleteCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCahce()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCahce()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteCahceOnNonExpiredCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusCategoriesCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCahce()
        store.completeRetrieval(with: categories.local, timestamp: nonExpiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deleteCacheOnExpiration() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusCategoriesCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCahce()
        store.completeRetrieval(with: categories.local, timestamp: expirationTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_validateCache_deleteExpiredCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusCategoriesCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCahce()
        store.completeRetrieval(with: categories.local, timestamp: expiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = CategoryStoreSpy()
        var sut: LocalCategoryLoader? = LocalCategoryLoader(store: store, currentDate: Date.init)
        
        sut?.validateCahce()
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCategoryLoader, store: CategoryStoreSpy) {
        let store = CategoryStoreSpy()
        let sut = LocalCategoryLoader(store: store, currentDate: currentDate)
        trackForMemoryLeacks(store, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, store)
    }
}
