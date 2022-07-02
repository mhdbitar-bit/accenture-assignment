@testable import accenture_assignment
import XCTest

final class loadCategoryFromCahceUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetreieval() {
        let (sut, store) = makeSUT()

        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedCategoriesOnLessThanSevenDaysoldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        // currentDate - (7 * 24 * 60 * 60)days + 1 second
        let lessThanSevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(categories.models)) {
            store.completeRetrieval(with: categories.local, timestamp: lessThanSevenDaysoldTimestamp)
        }
    }
    
    func test_load_deliversNoCategoriesOnSevenDaysoldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        // currentDate - (7 * 24 * 60 * 60)days
        let sevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: categories.local, timestamp: sevenDaysoldTimestamp)
        }
    }
    
    func test_load_deliversNoCategoriesOnMoreThanSevenDaysoldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        // currentDate - (7 * 24 * 60 * 60)days - 1 second
        let moreThanSevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: categories.local, timestamp: moreThanSevenDaysoldTimestamp)
        }
    }
    
    func test_load_deleteCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in}
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_load_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in}
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeleteCacheOnLessThanSevenDaysOldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load() { _ in}
        store.completeRetrieval(with: categories.local, timestamp: lessThanSevenDaysoldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_deleteCacheOnSevenDaysOldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let sevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load() { _ in}
        store.completeRetrieval(with: categories.local, timestamp: sevenDaysoldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_load_deleteCacheOnMoreThanSevenDaysOldCache() {
        let categories = uniqueCategories()
        let fixedCurrentDate = Date()
        let moreThanSevenDaysoldTimestamp = fixedCurrentDate.adding(days: -7).adding(days: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load() { _ in}
        store.completeRetrieval(with: categories.local, timestamp: moreThanSevenDaysoldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCahcedCategories])
    }
    
    func test_load_doesNotDeleiverResultAfterSUTInstanceHasBeenDeallicated() {
        let store = CategoryStoreSpy()
        var sut: LocalCategoryLoader? = LocalCategoryLoader(store: store, currentDate: Date.init)
        
        var receivedResult = [LocalCategoryLoader.LoadResult]()
        sut?.load { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCategoryLoader, store: CategoryStoreSpy) {
        let store = CategoryStoreSpy()
        let sut = LocalCategoryLoader(store: store, currentDate: currentDate)
        trackForMemoryLeacks(store, file: file, line: line)
        trackForMemoryLeacks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalCategoryLoader, toCompleteWith expectedResult: LocalCategoryLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedCategories), .success(expectedCategories)):
                XCTAssertEqual(receivedCategories, expectedCategories, file: file, line: line)
              
            case let (.failure(receivedError as NSError), .failure(expectedCategories as NSError)):
                XCTAssertEqual(receivedError, expectedCategories, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func uniqueCategory() -> CategoryItem {
        CategoryItem(id: 1, name: "any")
    }

    private func uniqueCategories() -> (models: [CategoryItem], local: [LocalCategoryItem]) {
        let models = [uniqueCategory(), uniqueCategory()]
        let local = models.map { LocalCategoryItem(id: $0.id, name: $0.name) }
        return (models, local)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}

private extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
