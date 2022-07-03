@testable import accenture_assignment
import XCTest

class CodableCategoriesStore {
    private struct Cache: Codable {
        let categories: [CodableCategories]
        let timestamp: Date
        
        var localCategories: [LocalCategoryItem] {
            return categories.map { $0.local }
        }
    }
    
    private struct CodableCategories: Codable {
        private let id: Int
        private let name: String
        
        init(_ category: LocalCategoryItem) {
            id = category.id
            name = category.name
        }
        
        var local: LocalCategoryItem {
            return LocalCategoryItem(id: id, name: name)
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping CategoryStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(categories: cache.localCategories, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping CategoryStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()
            let cache = Cache(categories: categories.map(CodableCategories.init), timestamp: timestamp)
            let encoded = try encoder.encode(cache)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteCachedCategories(completion: @escaping CategoryStore.DeletionCompletion) {
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return completion(.none)
        }
        
        try! FileManager.default.removeItem(at: storeURL)
        completion(.none)
    }
}

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
    
    func test_retrieve_deliversFailureOnRetrievealError() {
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
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> CodableCategoriesStore {
        let sut = CodableCategoriesStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(_ cache: (categories: [LocalCategoryItem], timestamp: Date), to sut: CodableCategoriesStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        sut.insert(cache.categories, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    private func expect(_ sut: CodableCategoriesStore, toRetrieveTwice expectedResult: RetrieveCachedCategoriesResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableCategoriesStore, toRetrieve expectedResult: RetrieveCachedCategoriesResult, file: StaticString = #filePath, line: UInt = #line) {
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
    
    private func deleteCache(from sut: CodableCategoriesStore) -> Error? {
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
}
