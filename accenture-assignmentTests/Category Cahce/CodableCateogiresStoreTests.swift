@testable import accenture_assignment
import XCTest

class CodableCategoriesStore {
    func retrieve(completion: @escaping CategoryStore.RetrievalCompletion) {
        completion(.empty)
    }
}

final class CodableCateogiresStoreTests: XCTestCase {

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
}
