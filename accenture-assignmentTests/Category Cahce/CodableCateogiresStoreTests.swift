@testable import accenture_assignment
import XCTest

final class CodableCateogiresStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieveDeliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let categories = uniqueCategories().local
        let timestamp = Date()
        
        insert((categories, timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(categories: categories, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let categories = uniqueCategories().local
        let timestamp = Date()
        
        insert((categories, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(categories: categories, timestamp: timestamp))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslynsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert((uniqueCategories().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cahce successfuly")
        
        let latestCategories = uniqueCategories().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestCategories, latestTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to pverride cache successfuly")
        expect(sut, toRetrieve: .found(categories: latestCategories, timestamp: latestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let categories = uniqueCategories().local
        let timestamp = Date()
        
        let insertionError = insert((categories, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert((uniqueCategories().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completionOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueCategories().local, timestamp: Date()) { _ in
            completionOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedCategories { _ in
            completionOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueCategories().local, timestamp: Date()) { _ in
            completionOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completionOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> CategoryStore {
        let sut = CodableCategoryStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(_ cache: (categories: [LocalCategoryItem], timestamp: Date), to sut: CategoryStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        sut.insert(cache.categories, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    private func expect(_ sut: CategoryStore, toRetrieveTwice expectedResult: RetrieveCachedCategoriesResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CategoryStore, toRetrieve expectedResult: RetrieveCachedCategoriesResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break

            case let (.found(categories: expectedCategories, timestamp: expectedTimestamp), .found(categories: retrievedCategories, timestamp: retrievedTimestamp)):
                XCTAssertEqual(expectedCategories, retrievedCategories, file: file, line: line)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func deleteCache(from sut: CategoryStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedCategories { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }

    
    private func setupEmptyStoreState() {
        deleteStoreArtifcats()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifcats()
    }
    
    private func deleteStoreArtifcats() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
}
