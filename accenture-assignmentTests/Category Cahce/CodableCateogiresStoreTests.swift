@testable import accenture_assignment
import XCTest

class CodableCategoriesStore {
    private struct Cache: Codable {
        let categories: [LocalCategoryItem]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
    
    func retrieve(completion: @escaping CategoryStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            completion(.empty)
            return
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(categories: cache.categories, timestamp: cache.timestamp))
    }
    
    func insert(_ categories: [LocalCategoryItem], timestamp: Date, completion: @escaping CategoryStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(Cache(categories: categories, timestamp: timestamp))
        try! encoded.write(to: storeURL)
        completion(.none)
    }
}

final class CodableCateogiresStoreTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override class func tearDown() {
        super.tearDown()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableCategoriesStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableCategoriesStore()
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
        let sut = CodableCategoriesStore()
        let categories = uniqueCategories().local
        let timestamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(categories, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected categories to be inserted successfully")
            
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(categories: retrievedCategories, timestamp: retrievedTimestamp):
                    XCTAssertEqual(retrievedCategories, categories)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                
                default:
                    XCTFail("Expected found result with categories \(categories) and \(timestamp), got \(retrieveResult) instead")
                }
            
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
