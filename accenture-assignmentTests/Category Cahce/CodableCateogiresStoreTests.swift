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
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(categories: cache.localCategories, timestamp: cache.timestamp))
    }
    
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping CategoryStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(categories: categories.map(CodableCategories.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
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
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let categories = uniqueCategories().local
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for cache retrieval")
        sut.insert(categories, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected categories to be inserted successfully")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieve: .found(categories: categories, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let categories = uniqueCategories().local
        let timestamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(categories, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected categories to be inserted successfully")
            
            sut.retrieve { firstResult in
                sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case let (.found(firstFound), .found(secondFound)):
                    XCTAssertEqual(firstFound.categories, categories)
                    XCTAssertEqual(firstFound.timestamp, timestamp)

                    XCTAssertEqual(secondFound.categories, categories)
                    XCTAssertEqual(secondFound.timestamp, timestamp)

                    default:
                        XCTFail("Expected retrieving twice from non empty caceh to deliver same found result categories \(categories) and \(timestamp), got \(firstResult) and \(secondResult) instead")
                    }
                
                    exp.fulfill()
                
                }
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableCategoriesStore {
        let sut = CodableCategoriesStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeacks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CodableCategoriesStore, toRetrieve expectedResult: RetrieveCachedCategoriesResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
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
